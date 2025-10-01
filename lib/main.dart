import 'package:flutter/material.dart';
import './screen/student_screen.dart';
import './screen/course_screen.dart';
import './screen/exam_result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/students': (context) => const StudentScreen(),
        '/courses': (context) => const CourseScreen(),
        '/exam_results': (context) => const ExamResultScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Menu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Students"),
              onPressed: () => Navigator.pushNamed(context, '/students'),
            ),
            ElevatedButton(
              child: const Text("Courses"),
              onPressed: () => Navigator.pushNamed(context, '/courses'),
            ),
            ElevatedButton(
              child: const Text("Exam Results"),
              onPressed: () => Navigator.pushNamed(context, '/exam_results'),
            ),
          ],
        ),
      ),
    );
  }
}
