import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/exam_result.dart';

class EditExamResultScreen extends StatefulWidget {
  final ExamResult examResult;

  EditExamResultScreen({required this.examResult});

  @override
  _EditExamResultScreenState createState() => _EditExamResultScreenState();
}

class _EditExamResultScreenState extends State<EditExamResultScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _studentController;
  late TextEditingController _courseController;
  late TextEditingController _scoreController;

  @override
  void initState() {
    super.initState();
    _studentController =
        TextEditingController(text: widget.examResult.studentCode);
    _courseController =
        TextEditingController(text: widget.examResult.courseCode);
    _scoreController =
        TextEditingController(text: widget.examResult.score);
  }

  Future<void> _editResult() async {
    final response = await http.put(
      Uri.parse('http://10.96.4.128/Suwatchai/api/exam_result.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "result_id": widget.examResult.resultId,
        "student_code": _studentController.text,
        "course_code": _courseController.text,
        "score": _scoreController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update exam result")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Exam Result")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _studentController,
                decoration: InputDecoration(labelText: "Student Code"),
                validator: (value) =>
                    value!.isEmpty ? "Enter student code" : null,
              ),
              TextFormField(
                controller: _courseController,
                decoration: InputDecoration(labelText: "Course Code"),
                validator: (value) =>
                    value!.isEmpty ? "Enter course code" : null,
              ),
              TextFormField(
                controller: _scoreController,
                decoration: InputDecoration(labelText: "Score"),
                validator: (value) => value!.isEmpty ? "Enter score" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _editResult();
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
