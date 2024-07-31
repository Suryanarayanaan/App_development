import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo/features/app/splash_screen/splash_screen.dart';
import 'package:demo/features/user_auth/presentation/pages/home_page.dart';
import 'package:demo/features/user_auth/presentation/pages/login_page.dart';
import 'package:demo/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:demo/features/user_auth/presentation/pages/LiveWeatherForecast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => const SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) {
          // Extract the username and contact passed as arguments
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;
          final String username = args?['username'] ?? '';
          final String contact = args?['contact'] ?? '';
          return HomePage(username: username, contact: contact);
        },
      },
    );
  }
}
