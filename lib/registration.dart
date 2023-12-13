import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

enum UserRole { Child, Parent, Counsellor }

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _familyCodeController = TextEditingController();

  UserRole _selectedRole = UserRole.Child; // Default role

  void _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the UID of the newly registered user
      String uid = userCredential.user!.uid;

      // Store user data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': _emailController.text,
        'uid': uid,
        'password': _passwordController.text,
        'name': _nameController.text,
        'familyCode': _familyCodeController.text,
        'role':
            _selectedRole.toString().split('.').last, // Store the selected role
      });

      // Navigate to the next screen or perform other actions as needed
    } catch (e) {
      print('Registration error: $e');
      // Handle registration errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _familyCodeController,
              decoration: InputDecoration(labelText: 'Family Code'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              onChanged: (UserRole? value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
              items: UserRole.values.map((UserRole role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
