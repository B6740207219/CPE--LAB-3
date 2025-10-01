import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/course.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> courses;

  @override
  void initState() {
    super.initState();
    courses = fetchCourses();
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse("http://10.96.4.128/Suwatchai/api/course.php"),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Course.fromJson(data)).toList();
    } else {
      throw Exception("Failed to load courses");
    }
  }

  Future<void> deleteCourse(String courseCode) async {
    final response = await http.delete(
      Uri.parse("http://10.96.4.128/Suwatchai/api/course.php?course_id=$courseCode"),
      headers: {"Content-Type": "application/json"},
    );

    print('DELETE response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      _refreshData();
    } else {
      throw Exception("Failed to delete course: ${response.statusCode}");
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      courses = fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  AddCourseScreen()),
              );
              if (result == true) _refreshData();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Course>>(
          future: courses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No courses"));
            }

            final courseList = snapshot.data!;
            return ListView.separated(
              itemCount: courseList.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final course = courseList[index];
                return ListTile(
                  title: Text(course.courseName),
                  subtitle: Text(
                      "Code: ${course.courseCode} | Credit: ${course.courseCredit}"),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditCourseScreen(course: course),
                            ),
                          );
                          if (result == true) _refreshData();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await deleteCourse(course.courseId);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
