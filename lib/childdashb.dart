import 'package:flutter/material.dart';
import 'package:psychalyzergpt/counsellordashb.dart';
import 'childlogin.dart';
import 'childtest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';

final Color blueViolet = Color(0xFF8A2BE2);

void main() => runApp(MyApp());

class ChildDashboard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      print('Logout error: $e');
      // Handle logout error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Psychalyzer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: blueViolet,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                'Logged in as a child',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pending tests',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: Colors.black,
                      height: 2,
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView(
                        children: <Widget>[
                          _buildQuizCard(
                            context,
                            'Quiz 001',
                          ),
                          _buildQuizCard(
                            context,
                            'Quiz 002',
                          ),
                          _buildQuizCard(
                            context,
                            'Quiz 003',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatBotPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: blueViolet,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'TALK Bot',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, String quizName) {
    return Card(
      color: blueViolet,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.quiz, color: Colors.white),
              title: Text(
                quizName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildTest(quizName: quizName),
                      ),
                    );
                  },
                  child: Text('Take the quiz'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add your chat bot page content here
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
      ),
      body: Center(
        child: Text('Chat Bot Page'),
      ),
    );
  }
}
