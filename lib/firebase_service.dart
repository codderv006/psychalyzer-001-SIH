import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveQuizResponses(
      String userId, List<Map<String, dynamic>> quizData) async {
    try {
      // Check the user role
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      String userRole = userSnapshot['role'];

      // Only save quiz responses for Parent or Child
      if (userRole == 'Parent' || userRole == 'Child') {
        // Create or get the 'quizzes' subcollection for the user
        CollectionReference quizzesCollection =
            usersCollection.doc(userId).collection('quizzes');

        // Check if the 'quizzes' collection exists, create it if not
        bool quizzesCollectionExists =
            await quizzesCollection.doc().get().then((doc) => doc.exists);

        if (!quizzesCollectionExists) {
          await usersCollection.doc(userId).set(
              {'quizzes': FieldValue.arrayUnion([])}, SetOptions(merge: true));
        }

        // Create a new document for each quiz
        DocumentReference quizDocument = await quizzesCollection.add({
          'timestamp': FieldValue.serverTimestamp(),
          'quiz_responses': [],
        });

        // Save each question and answer in the quiz document
        List<Map<String, dynamic>> quizResponses = [];

        for (int i = 0; i < quizData.length; i++) {
          Map<String, dynamic>? questionData = quizData[i];
          print('Processing response at index $i: $questionData');

          if (questionData != null) {
            String? question = questionData['question'];
            String? userAnswer = questionData['user_answer'] ?? 'Not Answered';

            // Print question and user answer to identify null values
            print('Question: $question, User Answer: $userAnswer');

            // Save question, user answer, and correct answer as fields in the quiz document
            quizResponses.add({
              'question': question,
              'user_answer': userAnswer,
            });
          } else {
            print('Null response at index $i');
          }
        }

        // Update the quiz document with the quiz responses
        await quizDocument.update({
          'quiz_responses': FieldValue.arrayUnion([...quizResponses]),
        });
      }
    } catch (e) {
      print('Error saving quiz responses: $e');
      // Handle the error as needed
    }
  }

  Future<String> getUserId() async {
    // Use Firebase Authentication to get the current user's ID
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User not logged in');
    }
  }

  // ... (other functions remain the same)
}
