import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/student.dart';

class StudentController extends GetxController {
  final students = <Student>[].obs;

  final studentNameController = TextEditingController();
  final studentIDController = TextEditingController();
  final selectedClasses = <String>[].obs;

  final studentPasswordController = TextEditingController();
  final loading = false.obs;

  @override
  void onInit() {
    getStudents();
    super.onInit();
  }

  void getStudents() {
    loading.value = true;
    FirebaseFirestore.instance
        .collection("classes")
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      students.clear();
      for (var element in value.docs) {
        students.add(Student.fromMap(element.data()));
      }
      print("students len ${students.length}");
      loading.value = false;
    }).catchError((error) {
      loading.value = false;
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  void reset() {
    studentNameController.clear();
    studentPasswordController.clear();
    studentIDController.clear();
    selectedClasses.clear();
  }

  bool validate() {
    if (studentNameController.text.isEmpty) {
      Get.snackbar("Error", "Student name cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (studentPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Student password cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (studentIDController.text.isEmpty) {
      Get.snackbar("Error", "Student ID cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  void addStudent(String userUid, String userName) {
    if (!validate()) {
      return;
    }
    loading.value = true;
    //a the class to the list
    students.add(
      Student(
        name: studentNameController.text,
        id: studentIDController.text,
        password: studentPasswordController.text,
        classes: selectedClasses,
        addedBy: userUid,
        createdAt: Timestamp.fromDate(DateTime.now()),
      ),
    );

    FirebaseFirestore.instance.collection("students").add({
      "name": studentNameController.text,
      "id": studentIDController.text,
      "password": studentPasswordController.text,
      "classes": selectedClasses,
      "addedBy": userUid,
      "createdAt": Timestamp.fromDate(DateTime.now()),
    }).then((value) {
      Get.snackbar("Success", "Student added successfully",
          snackPosition: SnackPosition.BOTTOM);
      reset();
      loading.value = false;
    }).catchError((error) {
      loading.value = false;
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    });
  }
}
