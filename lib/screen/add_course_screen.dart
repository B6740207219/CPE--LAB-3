import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  bool _isLoading = false;

  Future<void> addCourse() async {
    if (_nameController.text.isEmpty ||
        _codeController.text.isEmpty ||
        _creditController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://10.96.4.128/Suwatchai/api/course.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "course_name": _nameController.text.trim(),
          "course_code": _codeController.text.trim(),
          "course_credit": _creditController.text.trim(),
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add course: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error adding course: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Course Code'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _creditController,
              decoration: const InputDecoration(labelText: 'Course Credit'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: addCourse,
                    child: const Text('Add Course'),
                  ),
          ],
        ),
      ),
    );
  }
}
