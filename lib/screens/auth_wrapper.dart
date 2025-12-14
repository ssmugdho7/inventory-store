import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the auth service to access the stream
    final authService = AuthService();

    return StreamBuilder<User?>(
      // Listen to the auth state changes (login, logout, signup)
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        
        // 1. LOADING: Waiting for Firebase to confirm status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
          );
        }

        // 2. ERROR: If something went wrong with the stream
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong. Please restart the app.'),
            ),
          );
        }

        // 3. LOGGED IN: We have user data
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // 4. LOGGED OUT: No user data
        return const LoginScreen();
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
