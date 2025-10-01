class ExamResult {
  final String resultId;
  final String studentCode;
  final String courseCode;
  final String score;

  ExamResult({
    required this.resultId,
    required this.studentCode,
    required this.courseCode,
    required this.score,
  });

  // Constructor สำหรับแปลง JSON → ExamResult object
  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      resultId: json['result_id'],
      studentCode: json['student_code'],
      courseCode: json['course_code'],
      score: json['score'],
    );
  }

  // แปลง ExamResult → JSON (สำหรับ POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'result_id': resultId,
      'student_code': studentCode,
      'course_code': courseCode,
      'score': score,
    };
  }
}
