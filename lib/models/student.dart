// user modal, it'll have name, email, uid, createdAt
// Path: lib/models/user.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String name;
  final String id;
  final String password;
  final List<String> classes;
  final Timestamp createdAt;
  final String addedBy;

  Student({
    required this.name,
    required this.id,
    required this.password,
    required this.classes,
    required this.addedBy,
    required this.createdAt,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'],
      id: map['id'],
      password: map['password'],
      classes: map['classes'].toList().cast<String>(),
      addedBy: map['addedBy'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'password': password,
      'classes': classes,
      'addedBy': addedBy,
      'createdAt': createdAt,
    };
  }
}
