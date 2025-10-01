/// Model สำหรับข้อมูล Course
/// ทุก field เป็น String และไม่มีค่า null
class Course {
  final String courseId;
  final String courseName;
  final String courseCode;
  final String courseCredit;

  Course({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.courseCredit,
  });

  /// สร้าง Course จาก JSON
  /// ถ้า field ไหนเป็น null จะใช้ค่า default เป็น string ว่างหรือ '0' สำหรับ credit
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id']?.toString() ?? '',
      courseName: json['course_name']?.toString() ?? '',
      courseCode: json['course_code']?.toString() ?? '',
      courseCredit: json['course_credit']?.toString() ?? '3',
    );
  }

  /// แปลง Course เป็น JSON สำหรับส่งไป API
  Map<String, dynamic> toJson() {
    return {
      "course_id": courseId,
      "course_name": courseName,
      "course_code": courseCode,
      "course_credit": courseCredit,
    };
  }
  /// สร้าง copyWith สำหรับแก้ไข course
  Course copyWith({
    String? courseId,
    String? courseName,
    String? courseCode,
    String? courseCredit,
  }) {
    return Course(
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      courseCode: courseCode ?? this.courseCode,
      courseCredit: courseCredit ?? this.courseCredit,
    );
  }
}
