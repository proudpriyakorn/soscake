// lib/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext ctx) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(ctx).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.teal.shade700]))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(radius: 44, backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : const AssetImage('assets/images/1.png') as ImageProvider),
                  const SizedBox(height: 12),
                  Text(user?.email ?? 'Guest', style: const TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _signOut(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
