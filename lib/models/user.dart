// user modal, it'll have name, email, uid, createdAt
// Path: lib/models/user.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String name;
  final String email;
  final String uid;
  final bool isInstructor;
  final String createdAt;

  MyUser({
    required this.name,
    required this.email,
    required this.uid,
    required this.isInstructor,
    required this.createdAt,
  });

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      name: map['name'],
      email: map['email'],
      uid: map['uid'],
      isInstructor: map['isInstructor'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'isInstructor': isInstructor,
      'createdAt': createdAt,
    };
  }
}
