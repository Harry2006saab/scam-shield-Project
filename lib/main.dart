import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scam_shield/screens/home_screen.dart';
import 'package:scam_shield/screens/login_screen.dart';
import 'package:scam_shield/screens/register_screen.dart';
import 'package:scam_shield/screens/sms_detector_screen.dart';
import 'package:scam_shield/screens/url_detector_screen.dart';
import 'package:scam_shield/screens/ai_chat_screen.dart';
import 'package:scam_shield/services/auth_service.dart';
import 'package:scam_shield/theme/cyber_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found or failed to load");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ScamShieldApp());
}

class ScamShieldApp extends StatelessWidget {
  const ScamShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScamShield AI',
      theme: CyberTheme.darkTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/sms_detector': (context) => const SMSDetectorScreen(),
        '/url_detector': (context) => const URLDetectorScreen(),
        '/ai_chat': (context) => const AIChatScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: CyberTheme.primaryCyan),
            ),
          );
        }
        
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
