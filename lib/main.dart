import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'registration.dart';
import 'firebase_options.dart';
import 'package:psychalyzergpt/loginpage.dart';

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
      title: 'Flutter Redirect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Redirect to the SelectUser screen
    );
  }
}
