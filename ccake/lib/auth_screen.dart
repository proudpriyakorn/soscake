// lib/auth_screen.dart
import 'package:flutter/material.dart';
import 'onboarding_screens.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  bool isSignIn = true;

  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    Timer.periodic(const Duration(seconds: 3), (timer) {
      _logoController.forward().then((_) => _logoController.reverse());
      _textController.forward().then((_) => _textController.reverse());
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bau.gif',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo + Animated Text
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 16),
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _logoAnimation,
                          child: SizedBox(
                            width: 130,
                            height: 130,
                            child: Image.asset(
                              "assets/images/ponyo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _textAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _textAnimation.value),
                              child: child,
                            );
                          },
                          child: Text(
                            "Ponyo o-clock cakes",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFA3E3), // pink fill
                              fontFamily: 'Comic Sans MS', // playful font, replace with custom if available
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF8A0057), // dark purple border
                                  blurRadius: 0,
                                  offset: Offset(2, 2),
                                ),
                                Shadow(
                                  color: Color(0xFF8A0057),
                                  blurRadius: 0,
                                  offset: Offset(-2, -2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Auth Card
                  Container(
                    width: 380,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(222, 255, 200, 244),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Toggle Sign In / Sign Up
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 125, 232),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isSignIn = true),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isSignIn
                                          ? const Color.fromARGB(255, 45, 185, 232)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isSignIn
                                              ? Colors.white
                                              : const Color.fromARGB(255, 41, 1, 60),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isSignIn = false),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: !isSignIn
                                          ? const Color.fromARGB(255, 45, 185, 232)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: !isSignIn
                                              ? Colors.white
                                              : Color.fromARGB(255, 41, 1, 60),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: isSignIn ? _SignInForm() : _SignUpForm(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "© 2025 Ponyo App. All rights reserved.",
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- SIGN IN FORM -------------------
class _SignInForm extends StatefulWidget {
  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  Future<void> _signIn(BuildContext context) async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => OnboardingScreens()),
);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: const TextStyle(color: Colors.white70),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: const Color.fromARGB(255, 105, 100, 182),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.white70),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: const Color.fromARGB(255, 105, 100, 182),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              activeColor: const Color.fromARGB(255, 84, 211, 243),
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
            const Text(
              "Remember Me",
              style: TextStyle(color: Color.fromARGB(179, 59, 1, 60)),
            ),
          ],
        ),
        const SizedBox(height: 0),
        // --- Social/Other Sign In Options ---
        const Text(
          "or continue with",
          style: TextStyle(color: Color.fromARGB(179, 59, 1, 60), fontSize: 14),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () {},
          icon: const Icon(Icons.email),
          label: const Text("Continue with Email"),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () {},
          icon: const Icon(Icons.apple),
          label: const Text("Continue with Apple"),
        ),
        const SizedBox(height: 0),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
        // --- End Social/Other Sign In Options ---
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 45, 185, 232),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () => _signIn(context),
          child: const Text(
            "Sign In",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ------------------- SIGN UP FORM -------------------
class _SignUpForm extends StatefulWidget {
  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _selectedBirthdate;

  String? _validateName(String? value, String field) {
    if (value == null || value.trim().isEmpty) return "$field is required";
    if (value.length < 2) return "$field must be at least 2 characters";
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return "Passwords do not match";
    return null;
  }

  Future<void> _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
      });
    }
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate() && _selectedBirthdate != null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'birthdate': _selectedBirthdate!.toIso8601String(),
          });
        }

Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => OnboardingScreens()),
);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (_selectedBirthdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your birthdate'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: "First Name",
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: const Color.fromARGB(255, 105, 100, 182),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) => _validateName(value, "First name"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: "Last Name",
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: const Color.fromARGB(255, 105, 100, 182),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) => _validateName(value, "Last name"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email Address",
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: const Color.fromARGB(255, 105, 100, 182),
            ),
            style: const TextStyle(color: Colors.white),
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _selectBirthdate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 105, 100, 182),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Text(
                    _selectedBirthdate == null
                        ? 'Select Birthdate'
                        : '${_selectedBirthdate!.day}/${_selectedBirthdate!.month}/${_selectedBirthdate!.year}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedBirthdate == null
                          ? Colors.grey[400]
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: const Color.fromARGB(255, 105, 100, 182),
            ),
            style: const TextStyle(color: Colors.white),
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: const Color.fromARGB(255, 105, 100, 182),
            ),
            style: const TextStyle(color: Colors.white),
            validator: _validateConfirmPassword,
          ),
          // --- Social/Other Sign Up Options ---
          const SizedBox(height: 20),
          const Text(
            "or continue with",
            style: TextStyle(color: Color.fromARGB(179, 59, 1, 60)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {},
            icon: const Icon(Icons.email),
            label: const Text("Continue with Email"),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {},
            icon: const Icon(Icons.apple),
            label: const Text("Continue with Apple"),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
          // --- End Social/Other Sign Up Options ---
          const SizedBox(height: 0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 45, 185, 232),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: _createAccount,
            child: const Text(
              "Create Account",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
