import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loginpage.dart';
import 'firebase_service.dart';
import 'chatbot.dart';
import 'quiz.dart'; // Import the QuizPage

final Color blueViolet = Color(0xFF8A2BE2);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ParentDashboard(),
    );
  }
}

class ParentDashboard extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  void navigateToQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(onQuizCompleted: onQuizCompleted),
      ),
    );
  }

  void onQuizCompleted(List<Map<String, dynamic>> quizData) async {
    try {
      // Get the user ID
      String userId = await _firebaseService.getUserId() ?? '';

      // Save quiz responses to Firebase
      await _firebaseService.saveQuizResponses(userId, quizData);

      // Additional logic after saving the quiz responses
      // For example, show a success message or navigate to another page
    } catch (e) {
      print('Error saving quiz responses: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Psychalyzer'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
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
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView(
                    children: <Widget>[
                      for (var i = 0; i < 3; i++)
                        Card(
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
                                  leading:
                                      Icon(Icons.quiz, color: Colors.white),
                                  title: Text(
                                    'ADHD Quiz',
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
                                            builder: (context) =>
                                                InformationPage(),
                                          ),
                                        );
                                      },
                                      child: Text('ADHD Information'),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        navigateToQuiz(
                                            context); // Redirect to QuizPage
                                      },
                                      child: Text('Take the quiz'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Child's Report:",
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
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        _buildCircularSquare(Colors.red),
                        _buildCircularSquare(Colors.blue),
                        _buildCircularSquare(Colors.green),
                        _buildCircularSquare(Colors.yellow),
                      ],
                    ),
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
    );
  }

  Widget _buildCircularSquare(Color color) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// class QuizPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Page'),
//       ),
//       body: Center(
//         child: Text('This is the Quiz Page'),
//       ),
//     );
//   }
// }

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADHD Information Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSection(
                title: 'What is ADHD?',
                content:
                    'Attention-Deficit/Hyperactivity Disorder, commonly known as ADHD, is a neurodevelopmental disorder that affects both children and adults. It is characterized by persistent patterns of inattention, hyperactivity, and impulsivity that can significantly impact daily functioning.',
              ),
              _buildSection(
                title: 'Inattention Symptoms:',
                content: '• Difficulty staying focused on tasks.\n'
                    '• Frequent careless mistakes.\n'
                    '• Trouble organizing activities.\n'
                    '• Avoiding tasks requiring effort.\n'
                    '• Easily distracted.\n'
                    '• Forgetfulness in daily life.',
              ),
              _buildSection(
                title: 'Hyperactivity-Impulsivity Symptoms:',
                content: '• Fidgeting or restlessness.\n'
                    '• Inability to stay seated.\n'
                    '• Excessive talking.\n'
                    '• Interrupting others.\n'
                    '• Impatience, difficulty waiting turns.',
              ),
              _buildSection(
                title: 'Assessment:',
                content:
                    '• Clinical evaluation (symptoms, milestones, family history).\n'
                    '• Behavioral observations (school, home).\n'
                    '• Questionnaires and rating scales (teachers, parents, individual).\n'
                    '• Neuropsychological testing (attention, executive function).',
              ),
              _buildSection(
                title: 'Treatments:',
                content:
                    '• Medication : Includes stimulants (e.g., methylphenidate) or non-stimulants (e.g., atomoxetine).\n'
                    '• Educational Support : Provides academic accommodations and plans.\n'
                    '• Parent & Family Education : Teaches support strategies.\n'
                    '• Lifestyle Modifications : Routines, exercise, diet, and sleep.\n'
                    '• Individualized Approach : Tailored to the person\'s needs.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
