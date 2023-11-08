// user modal, it'll have name, email, uid, createdAt
// Path: lib/models/user.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String className;
  final String startTime;
  final String endTime;
  final String instructorName;
  final Timestamp createdAt;
  final String addedBy;
  final int totalStudents;

  Course({
    required this.className,
    required this.startTime,
    required this.endTime,
    required this.instructorName,
    required this.addedBy,
    required this.createdAt,
    required this.totalStudents,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      className: map['className'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      instructorName: map['instructorName'],
      addedBy: map['addedBy'],
      createdAt: map['createdAt'],
      totalStudents: map['totalStudents'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'startTime': startTime,
      'endTime': endTime,
      'instructorName': instructorName,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'totalStudents': totalStudents,
    };
  }
}
