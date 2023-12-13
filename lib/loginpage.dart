import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration.dart';
import 'childdashb.dart';
import 'parentdashb.dart';
import 'counsellordashb.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = authResult.user;

      if (user != null) {
        // Retrieve user role from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();
        String role = userDoc['role'];

        // Redirect based on the user's role
        switch (role) {
          case 'Child':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChildDashboard()),
            );
            break;
          case 'Parent':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ParentDashboard()),
            );
            break;
          case 'Counsellor':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CounselDashboard()),
            );
            break;
          default:
            // Handle unknown role
            _showErrorDialog(
                'Role Error', 'Invalid role. Please contact support.');
        }
      }
    } catch (e) {
      print('Login error: $e');
      // If user is not registered, show an alert
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        _showRegisterDialog();
      } else {
        _showErrorDialog(
            'Login Error', 'Invalid email or password. Please try again.');
      }
    }
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('User Not Registered'),
          content: Text('Do you want to register now?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
                // Navigate to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage(),
                  ),
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage(),
                  ),
                );
              },
              child: Text('Not registered? Register now'),
            ),
          ],
        ),
      ),
    );
  }
}
