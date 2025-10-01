import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // ใช้ compute

// ---------- MODEL ----------
class ExamResult {
  final String id;
  final String student;
  final String studentCode;
  final String course;
  final String courseCode;
  final double point;

  ExamResult({
    required this.id,
    required this.student,
    required this.studentCode,
    required this.course,
    required this.courseCode,
    required this.point,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id']?.toString() ?? '',
      student: json['student']?.toString() ?? '',
      studentCode: json['student_code']?.toString() ?? '',
      course: json['course']?.toString() ?? '',
      courseCode: json['course_code']?.toString() ?? '',
      point: double.tryParse(json['point'].toString()) ?? 0,
    );
  }
}

// ---------- PARSE FUNCTION ----------
List<ExamResult> parseExamResults(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ExamResult>((json) => ExamResult.fromJson(json)).toList();
}

// ---------- FETCH FUNCTION ----------
Future<List<ExamResult>> fetchExamResults() async {
  final response = await http.get(
    Uri.parse('http://10.96.4.128/Suwatchai/api/exam_result.php'),
  );
  if (response.statusCode == 200) {
    return compute(parseExamResults, response.body);
  } else {
    throw Exception('Failed to load exam results');
  }
}

// ---------- UI ----------
class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({super.key});

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  List<ExamResult> examResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    try {
      final results = await fetchExamResults(); // ✅ ใช้ fetch ที่รวมแล้ว
      setState(() {
        examResults = results;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _addResult() {
    TextEditingController studentCtrl = TextEditingController();
    TextEditingController studentCodeCtrl = TextEditingController();
    TextEditingController courseCtrl = TextEditingController();
    TextEditingController courseCodeCtrl = TextEditingController();
    TextEditingController scoreCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Exam Result"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentCtrl, decoration: const InputDecoration(hintText: "Student")),
              TextField(controller: studentCodeCtrl, decoration: const InputDecoration(hintText: "Student Code")),
              TextField(controller: courseCtrl, decoration: const InputDecoration(hintText: "Course")),
              TextField(controller: courseCodeCtrl, decoration: const InputDecoration(hintText: "Course Code")),
              TextField(controller: scoreCtrl, decoration: const InputDecoration(hintText: "Score"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                examResults.add(
                  ExamResult(
                    id: DateTime.now().millisecondsSinceEpoch.toString(), // mock id
                    student: studentCtrl.text,
                    studentCode: studentCodeCtrl.text,
                    course: courseCtrl.text,
                    courseCode: courseCodeCtrl.text,
                    point: double.tryParse(scoreCtrl.text) ?? 0,
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _editResult(int index) {
    TextEditingController studentCtrl = TextEditingController(text: examResults[index].student);
    TextEditingController studentCodeCtrl = TextEditingController(text: examResults[index].studentCode);
    TextEditingController courseCtrl = TextEditingController(text: examResults[index].course);
    TextEditingController courseCodeCtrl = TextEditingController(text: examResults[index].courseCode);
    TextEditingController scoreCtrl = TextEditingController(text: examResults[index].point.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Exam Result"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentCodeCtrl),
              TextField(controller: courseCtrl),
              TextField(controller: courseCodeCtrl),
              TextField(controller: scoreCtrl, keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                examResults[index] = ExamResult(
                  id: examResults[index].id,
                  student: studentCtrl.text,
                  studentCode: studentCodeCtrl.text,
                  course: courseCtrl.text,
                  courseCode: courseCodeCtrl.text,
                  point: double.tryParse(scoreCtrl.text) ?? 0,
                );
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _deleteResult(int index) {
    setState(() => examResults.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exam Results")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: examResults.length,
              itemBuilder: (context, index) => ListTile(
                title: Text("${examResults[index].student} (${examResults[index].studentCode})"),
                subtitle: Text(
                  "Course: ${examResults[index].course} [${examResults[index].courseCode}]\n"
                  "Score: ${examResults[index].point}",
                ),
                leading: CircleAvatar(child: Text(examResults[index].id)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _editResult(index)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteResult(index)),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addResult,
        child: const Icon(Icons.add),
      ),
    );
  }
}
