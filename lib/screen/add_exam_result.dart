import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddExamResultScreen extends StatefulWidget {
  const AddExamResultScreen({super.key});

  @override
  State<AddExamResultScreen> createState() => _AddExamResultScreenState();
}

class _AddExamResultScreenState extends State<AddExamResultScreen> {
  final _studentCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  final _pointCtrl = TextEditingController();

  Future<void> addExamResult() async {
    final response = await http.post(
      Uri.parse('http://10.96.4.128/api/exam_result.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student': _studentCtrl.text,
        'course': _courseCtrl.text,
        'point': double.tryParse(_pointCtrl.text) ?? 0,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      throw Exception('Failed to add exam result.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Exam Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _studentCtrl,
              decoration: const InputDecoration(labelText: 'Student'),
            ),
            TextField(
              controller: _courseCtrl,
              decoration: const InputDecoration(labelText: 'Course'),
            ),
            TextField(
              controller: _pointCtrl,
              decoration: const InputDecoration(labelText: 'Score'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addExamResult,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
