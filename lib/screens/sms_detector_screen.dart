import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scam_shield/services/ai_service.dart';
import 'package:scam_shield/theme/cyber_theme.dart';
import 'package:scam_shield/widgets/cyber_button.dart';

class SMSDetectorScreen extends StatefulWidget {
  const SMSDetectorScreen({super.key});

  @override
  State<SMSDetectorScreen> createState() => _SMSDetectorScreenState();
}

class _SMSDetectorScreenState extends State<SMSDetectorScreen> {
  final _smsController = TextEditingController();
  final _aiService = AIService();
  bool _isLoading = false;
  String? _result;

  Future<void> _analyzeSMS() async {
    if (_smsController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _result = null;
    });
    
    final response = await _aiService.analyzeSMS(_smsController.text);
    
    if (response.startsWith("Error")) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response),
            backgroundColor: CyberTheme.errorRed,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }

    setState(() {
      _result = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS SCAM DETECTOR')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'PASTE SMS CONTENT',
                style: TextStyle(color: CyberTheme.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _smsController,
                maxLines: 6,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter or paste the suspicious SMS here...',
                  fillColor: CyberTheme.surfaceColor,
                ),
              ),
              const SizedBox(height: 24),
              CyberButton(
                text: 'ANALYZE THREAT',
                onPressed: _analyzeSMS,
                isLoading: _isLoading,
                icon: Icons.security_rounded,
              ),
              if (_isLoading) ...[
                const SizedBox(height: 40),
                const SpinKitDoubleBounce(color: CyberTheme.primaryCyan, size: 50),
              ],
              if (_result != null) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: CyberTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: CyberTheme.primaryCyan.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.analytics_outlined, color: CyberTheme.primaryCyan),
                          const SizedBox(width: 12),
                          const Text('AI ANALYSIS RESULT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _result!,
                        style: const TextStyle(color: CyberTheme.textSecondary, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
