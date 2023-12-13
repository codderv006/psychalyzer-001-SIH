import 'package:flutter/material.dart';
import 'package:psychalyzergpt/reports.dart';
import 'parentdashb.dart';

class QuizPage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onQuizCompleted;

  const QuizPage({Key? key, required this.onQuizCompleted}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestion = 0;
  List<String?> _selectedOptions =
      List.filled(20, null); // Initialize with null for unanswered questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          "Question 1: How often has your child talked when he or she wasn't supposed to, or had people complain that he or she talked too much?",
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 2: How often has your child interrupted someone when they were talking?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 3: How often has your child had trouble waiting for his or her turn or waiting for other things?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          "Question 4: How often has your child blurt out answers in school without being called on, or blurt out answers when someone wasn't talking to him or her",
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 5: How often has your child had trouble being quiet when he or she was supposed to be quiet?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 6: How often has your child been on the go, moving from one place to another?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 7: How often has your child run or climbed on things when he or she was not supposed to?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          "Question 8: How often has your child felt fidgety, like it was hard to sit without bouncing his or her leg or getting up and moving around?",
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          '9. How often has your child forgotten something somewhere or forgotten to do something he or she was supposed to do?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 10: How often has your child lost his or her homework, pencils, jacket, cell phone, or anything else big or small?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 11: How often has your child had trouble organizing his or her homework or other tasks?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 12: How often has your child not followed instructions that a parent or teacher said to him or her, or instructions on an assignment or test?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 13: How often has your child forgotten or tuned out what you or their teachers said to him or her?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 14: How many days has your child made a careless mistake?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 15: How often has your child had trouble staying in his or her seat at school or at home when your child was expected to stay seated?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 16: How often has your child had difficulty transitioning from one activity or task to another?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 17: How often has your child struggled to complete self-care tasks independently, such as dressing, bathing, or grooming?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    {
      'question':
          'Question 18: How often has your child been disorganized in managing personal belongings, often losing or misplacing items?',
      'options': ['Very Often', 'Often', 'Sometimes', 'Not Really'],
    },
    // Add more questions here
  ];
  void _selectOption(int questionIndex, String option) {
    setState(() {
      _selectedOptions[questionIndex] = option;
    });

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      List<Map<String, dynamic>> _getQuizData() {
        List<Map<String, dynamic>> quizData = [];
        for (int i = 0; i < _questions.length; i++) {
          quizData.add({
            'question': _questions[i]['question'],
            'user_answer': _selectedOptions[i],
          });
        }
        return quizData;
      }

      int totalScore = _calculateScore(_selectedOptions);
      widget.onQuizCompleted(_getQuizData());

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Quiz Submitted Successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportsPage(
                      responses: _selectedOptions,
                      totalScore: totalScore,
                    ),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  int _calculateScore(List<String?> responses) {
    int totalScore = 0;
    for (String? response in responses) {
      if (response == 'Very Often') {
        totalScore += 4;
      } else if (response == 'Often') {
        totalScore += 3;
      } else if (response == 'Sometimes') {
        totalScore += 2;
      } else if (response == 'Not Really') {
        totalScore += 1;
      }
    }
    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentQuestion < _questions.length
            ? _buildQuestion(_questions[_currentQuestion])
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Quiz Completed'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportsPage(
                              responses: _selectedOptions,
                              totalScore: _calculateScore(_selectedOptions),
                            ),
                          ),
                        );
                      },
                      child: Text('Display Report'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildQuestion(Map<String, dynamic> questionData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionData['question'],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: List.generate(
            questionData['options'].length,
            (index) => _buildOptionButton(
              questionData['options'][index],
              () => _selectOption(
                  _currentQuestion, questionData['options'][index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // Background color of the button
            onPrimary: Colors.black, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(option),
              Checkbox(
                value: _selectedOptions[_currentQuestion] == option,
                onChanged: (_) => onPressed(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
