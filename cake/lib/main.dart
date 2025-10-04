// ----------------------------
// 1. Dart SDK imports
// ----------------------------
import 'dart:async';
import 'dart:convert';

// ----------------------------
// 2. Flutter imports
// ----------------------------
import 'package:flutter/material.dart';

// ----------------------------
// 3. Third-party packages
// ----------------------------
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ----------------------------
// 4. Local project imports
// ----------------------------
import 'firebase_options.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'onboarding_screens.dart';
import 'product_list_provider.dart';  // ✅ now separated

/// ----------------------------
/// Main Entry Point
/// ----------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SosCakeApp());
}

/// ----------------------------
/// Root App Widget
/// ----------------------------
class SosCakeApp extends StatelessWidget {
  const SosCakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductListProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '!sos!cake',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.blue.shade900,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const RootDecider(),
          '/onboarding': (ctx) => const OnboardingScreens(),
          '/home': (ctx) => const HomeScreen(),
          '/auth': (ctx) => const AuthScreen(),
        },
      ),
    );
  }
}

/// ----------------------------
/// RootDecider → Chooses screen
/// ----------------------------
class RootDecider extends StatefulWidget {
  const RootDecider({super.key});
  @override
  State<RootDecider> createState() => _RootDeciderState();
}

class _RootDeciderState extends State<RootDecider> {
  StreamSubscription<User?>? _sub;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _sub = FirebaseAuth.instance.authStateChanges().listen((u) {
      setState(() => _user = u);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If not logged in → go to Auth, else Home
    return _user == null ? const HomeScreen() : const HomeScreen();
  }
}
