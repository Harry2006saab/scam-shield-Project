import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scam_shield/services/auth_service.dart';
import 'package:scam_shield/services/ai_service.dart';
import 'package:scam_shield/theme/cyber_theme.dart';
import 'package:scam_shield/widgets/cyber_button.dart';
import 'package:scam_shield/widgets/app_logo.dart';
import 'package:scam_shield/widgets/dashboard_card.dart';
import 'package:scam_shield/widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SCAMSHIELD DASHBOARD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new_rounded, color: CyberTheme.primaryCyan),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    Row(
                      children: [
                        const AppLogo(size: 60),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WELCOME, AGENT',
                                style: TextStyle(
                                  color: CyberTheme.accentNeon,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                user?.email?.split('@')[0].toUpperCase() ?? 'UNKNOWN',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: CyberTheme.accentNeon.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: CyberTheme.accentNeon.withValues(alpha: 0.3)),
                          ),
                          child: const Text(
                            'LEVEL 1',
                            style: TextStyle(color: CyberTheme.accentNeon, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Security Score Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [CyberTheme.primaryCyan.withValues(alpha: 0.15), Colors.transparent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: CyberTheme.primaryCyan.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SECURITY SCORE',
                                  style: TextStyle(color: CyberTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      '98',
                                      style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '/100',
                                      style: TextStyle(color: CyberTheme.textSecondary, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'SYSTEM OPTIMIZED',
                                  style: TextStyle(color: CyberTheme.accentNeon, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                  value: 0.98,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.white10,
                                  color: CyberTheme.primaryCyan,
                                ),
                              ),
                              const Icon(Icons.shield_rounded, color: CyberTheme.primaryCyan, size: 32),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Connection Test Button
                    CyberButton(
                      text: 'TEST AI CONNECTION',
                      isSecondary: true,
                      icon: Icons.electrical_services_rounded,
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Testing connection to Gemini...')),
                        );
                        final result = await AIService().testConnection();
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: CyberTheme.surfaceColor,
                              title: const Text('AI Status', style: TextStyle(color: CyberTheme.primaryCyan)),
                              content: Text(result, style: const TextStyle(color: Colors.white70)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),

                    // Quick Actions
                    const Text(
                      'ACTIVE DEFENSE PROTOCOLS',
                      style: TextStyle(color: CyberTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                    ),
                    const SizedBox(height: 16),
                    DashboardCard(
                      title: 'SCAN URL',
                      subtitle: 'Analyze links for malicious intent',
                      icon: Icons.link_rounded,
                      onTap: () => Navigator.pushNamed(context, '/url_detector'),
                    ),
                    const SizedBox(height: 12),
                    DashboardCard(
                      title: 'ANALYZE SMS',
                      subtitle: 'Detect smishing and fraud attempts',
                      icon: Icons.sms_failed_rounded,
                      accentColor: Colors.orangeAccent,
                      onTap: () => Navigator.pushNamed(context, '/sms_detector'),
                    ),
                    const SizedBox(height: 12),
                    DashboardCard(
                      title: 'AI SECURITY ASSISTANT',
                      subtitle: 'Real-time threat consultation',
                      icon: Icons.psychology_rounded,
                      accentColor: Colors.purpleAccent,
                      onTap: () => Navigator.pushNamed(context, '/ai_chat'),
                    ),
                    const SizedBox(height: 32),

                    // Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'BLOCKED',
                            value: '124',
                            icon: Icons.block_flipped,
                            color: CyberTheme.errorRed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'SCANNED',
                            value: '1.2k',
                            icon: Icons.radar_rounded,
                            color: CyberTheme.accentNeon,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'ALERTS',
                            value: '02',
                            icon: Icons.warning_amber_rounded,
                            color: Colors.yellowAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Recent Activity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RECENT ACTIVITY LOG',
                          style: TextStyle(color: CyberTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('VIEW ALL', style: TextStyle(color: CyberTheme.primaryCyan, fontSize: 10)),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final items = [
                          {'title': 'Link Scan', 'time': '2m ago', 'status': 'SECURE', 'color': CyberTheme.accentNeon},
                          {'title': 'SMS Analysis', 'time': '1h ago', 'status': 'THREAT', 'color': CyberTheme.errorRed},
                          {'title': 'URL Scan', 'time': '3h ago', 'status': 'SECURE', 'color': CyberTheme.accentNeon},
                        ];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CyberTheme.surfaceColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: items[index]['color'] as Color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items[index]['title'] as String,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      items[index]['time'] as String,
                                      style: const TextStyle(color: CyberTheme.textSecondary, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                items[index]['status'] as String,
                                style: TextStyle(color: items[index]['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
