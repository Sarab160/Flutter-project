import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/forgot.dart';
import 'screens/home_dashboard.dart';
import 'screens/prediction_screen.dart';
import 'screens/prediction_history.dart';
import 'screens/model_insights.dart';
import 'screens/hazards_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the bundled .env asset before anything else.
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await themeService.init();
  runApp(const AirSenseApp());
}

class AirSenseApp extends StatefulWidget {
  const AirSenseApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<AirSenseApp> createState() => _AirSenseAppState();
}

class _AirSenseAppState extends State<AirSenseApp> {
  @override
  void initState() {
    super.initState();
    // Monitor authentication state changes globally, but with a slight delay
    // to allow the SplashScreen to handle the initial landing.
    Future.delayed(const Duration(seconds: 4), () {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          final context = AirSenseApp.navigatorKey.currentContext;
          if (context != null) {
            try {
              AirSenseApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            } catch (e) {
              debugPrint('Global Auth Redirect Error: $e');
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService.themeMode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          navigatorKey: AirSenseApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Air Sense',
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFFBFDF9),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF009E74),
              primary: const Color(0xFF009E74),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF101412),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF009E74),
              primary: const Color(0xFF009E74),
              brightness: Brightness.dark,
            ),
          ),
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/forgot_password': (context) => const ForgotPasswordScreen(),
            '/home': (context) => const HomeDashboardScreen(),
            '/prediction': (context) => const PredictionScreen(),
            '/history': (context) => const PredictionHistoryScreen(),
            '/insights': (context) => const ModelInsightsScreen(),
            '/hazards': (context) => const HazardsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/edit_profile': (context) => const EditProfileScreen(),
          },
        );
      },
    );
  }
}
