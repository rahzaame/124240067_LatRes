import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101B2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2A41),
        title: const Text(
          'Rick & Morty Explorer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Rick & Morty Explorer!',
          style: TextStyle(
            color: Color(0xFF65D6AD),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
