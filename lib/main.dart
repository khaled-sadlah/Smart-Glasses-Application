import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'Screens/welcome_page.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/QR.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _needsQR() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('needsQR') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          if (!snap.hasData) {
            return const WelcomePage();
          }

          return FutureBuilder<bool>(
            future: _needsQR(),
            builder: (context, prefSnap) {
              if (prefSnap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              final needsQR = prefSnap.data ?? false;

              if (needsQR) {
                return const QRPage(isFirstAfterLogin: true);
              }
              return const HomePage();
            },
          );
        },
      ),
    );
  }
}
