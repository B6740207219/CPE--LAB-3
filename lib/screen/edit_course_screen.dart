import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;
  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _creditController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course.courseName);
    _codeController = TextEditingController(text: widget.course.courseCode);
    _creditController = TextEditingController(text: widget.course.courseCredit);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  Future<void> updateCourse() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse(
            "http://10.96.4.128/Suwatchai/api/course.php?course_code=${widget.course.courseCode}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "course_name": _nameController.text.trim(),
          "course_code": _codeController.text.trim(),
          "course_credit": _creditController.text.trim(),
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context, true); // ส่ง true กลับเพื่อ refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update course: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating course: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> deleteCourse() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this course?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final response = await http.delete(Uri.parse(
          "http://10.96.4.128/Suwatchai/api/course.php?course_code=${widget.course.courseCode}"));
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete course: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting course: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: updateCourse,
                        child: const Text('Save Changes'),
                      ),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: deleteCourse,
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
