import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  GenerativeModel? _model;

  // Using 'gemini-1.5-flash' as requested for latest stable compatibility
  static const String _modelName = 'gemini-1.5-flash';

  void _init() {
    try {
      debugPrint('🔍 AIService: Initializing with model: $_modelName');
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('❌ AIService Error: GEMINI_API_KEY is missing in .env');
        return;
      }

      // Safety settings - set to most permissive for cybersecurity analysis
      final safetySettings = [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ];

      // Using the GenerativeModel constructor with 'gemini-1.5-flash'
      _model = GenerativeModel(
        model: _modelName,
        apiKey: apiKey,
        safetySettings: safetySettings,
      );
      debugPrint('✅ AIService: Gemini Model ($_modelName) Initialized Successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ AIService Initialization Exception: ${e.runtimeType} - $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  Future<String> _executeWithRetry(Future<GenerateContentResponse> Function() action, {int retries = 3}) async {
    int attempts = 0;
    while (attempts <= retries) {
      try {
        if (_model == null) _init();
        if (_model == null) throw Exception("Model failed to initialize");

        final response = await action();
        final text = response.text;
        
        if (text == null || text.isEmpty) {
          if (response.candidates.isNotEmpty) {
            final reason = response.candidates.first.finishReason;
            debugPrint('⚠️ AIService: Empty text response. FinishReason: $reason');
            if (reason == FinishReason.safety) {
              return "Error: Analysis blocked by AI safety filters. This content might be too sensitive for the AI.";
            }
          }
          throw Exception("Empty response from AI");
        }
        
        debugPrint('📡 AIService SUCCESS: Response from $_modelName, length ${text.length}');
        return text;
      } catch (e, stackTrace) {
        attempts++;
        debugPrint('⚠️ AIService Attempt $attempts failed: $e');
        
        if (attempts > retries) {
          debugPrint('❌ AIService final failure: $e');
          debugPrint('StackTrace: $stackTrace');
          return "Error: $e. Please check your connection or try again later.";
        }
        
        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: attempts * 2));
      }
    }
    return "Error: Maximum retries reached.";
  }

  Future<String> testConnection() async {
    debugPrint('⏳ AIService: Running testConnection using $_modelName...');
    return await _executeWithRetry(() => _model!.generateContent([
      Content.text("Respond with exactly: 'Connection Successful' if you are active.")
    ]).timeout(const Duration(seconds: 10)));
  }

  Future<String> analyzeSMS(String smsContent) async {
    final prompt = '''
    Role: Cybersecurity Analyst
    Task: Analyze the following SMS for scams, phishing, or banking fraud.
    SMS: "$smsContent"
    
    Format your response EXACTLY like this:
    Score: [0-100]
    Level: [Safe/Suspicious/Dangerous]
    Explanation: [Detailed technical analysis]
    ''';

    debugPrint('⏳ AIService: Analyzing SMS threat with $_modelName...');
    return await _executeWithRetry(() => _model!.generateContent([Content.text(prompt)])
        .timeout(const Duration(seconds: 15)));
  }

  Future<String> analyzeURL(String url) async {
    final prompt = '''
    Role: Phishing Expert
    Task: Analyze the following URL for malware or phishing indicators.
    URL: "$url"
    
    Format your response EXACTLY like this:
    Score: [0-100]
    Level: [Safe/Suspicious/Dangerous]
    Explanation: [Domain and pattern analysis]
    Recommendations: [Security advice]
    ''';

    debugPrint('⏳ AIService: Analyzing URL threat with $_modelName...');
    return await _executeWithRetry(() => _model!.generateContent([Content.text(prompt)])
        .timeout(const Duration(seconds: 15)));
  }

  Future<String> getChatResponse(String message, List<Content> history) async {
    if (_model == null) _init();
    if (_model == null) return "Error: Model not initialized.";

    try {
      debugPrint('⏳ AIService: Chatting with $_modelName...');
      final chat = _model!.startChat(history: history);
      final response = await chat.sendMessage(Content.text(
        "You are ScamShield AI, a professional cybersecurity assistant. Help the user with: $message"
      )).timeout(const Duration(seconds: 20));
      
      final text = response.text;
      if (text == null) return "Error: AI returned null response.";
      debugPrint('📡 AIService Chat SUCCESS: Response length ${text.length}');
      return text;
    } catch (e, stackTrace) {
      debugPrint('❌ AIService Chat Exception: $e');
      debugPrint('StackTrace: $stackTrace');
      return 'Error: $e';
    }
  }
}
