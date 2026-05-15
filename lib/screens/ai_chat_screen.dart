import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:scam_shield/services/ai_service.dart';
import 'package:scam_shield/theme/cyber_theme.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _messageController = TextEditingController();
  final _aiService = AIService();
  final List<Map<String, dynamic>> _messages = [];
  final List<Content> _history = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    
    final userMessage = _messageController.text;
    setState(() {
      _messages.add({'text': userMessage, 'isUser': true});
      _isLoading = true;
    });
    _messageController.clear();

    final response = await _aiService.getChatResponse(userMessage, _history);
    
    setState(() {
      _messages.add({'text': response, 'isUser': false});
      _history.add(Content.text(userMessage));
      _history.add(Content.model([TextPart(response)]));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI SECURITY ASSISTANT')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(
                  text: msg['text'],
                  isUser: msg['isUser'],
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: LinearProgressIndicator(color: CyberTheme.primaryCyan, backgroundColor: Colors.transparent),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CyberTheme.surfaceColor,
              border: Border(top: BorderSide(color: CyberTheme.primaryCyan.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Ask about a scam or security...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: CyberTheme.primaryCyan),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? CyberTheme.primaryCyan.withValues(alpha: 0.1) : CyberTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
          ),
          border: Border.all(
            color: isUser ? CyberTheme.primaryCyan.withValues(alpha: 0.3) : Colors.white10,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : CyberTheme.textSecondary),
        ),
      ),
    );
  }
}
