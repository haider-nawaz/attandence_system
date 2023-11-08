import 'dart:ffi';

import 'package:attandence_system/models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class ClassController extends GetxController {
  //list of classes
  final classes = <Course>[].obs;
  //controllers for the textfields
  final TextEditingController classNameController = TextEditingController();

  //controller for start time and end time
  final startTimeController = TextEditingController().obs;
  final endTimeController = TextEditingController().obs;

  final loading = false.obs;

  @override
  void onInit() {
    startTimeController.value.text = "00:00";
    endTimeController.value.text = "00:00";
    getClasses();
    super.onInit();
  }

  //a function to get the list of classes
  void getClasses() {
    loading.value = true;
    FirebaseFirestore.instance
        .collection("classes")
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      classes.clear();
      for (var element in value.docs) {
        classes.add(Course.fromMap(element.data()));
      }
      print("classes len ${classes.length}");
      loading.value = false;
    }).catchError((error) {
      loading.value = false;
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  //function to reset the textfields
  void reset() {
    classNameController.clear();
    startTimeController.value.text = "00:00";
    endTimeController.value.text = "00:00";
  }

  //function to validate the textfields
  bool validate() {
    if (classNameController.text.isEmpty) {
      Get.snackbar("Error", "Class name cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (startTimeController.value.text == "00:00") {
      Get.snackbar("Error", "Start time cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (endTimeController.value.text == "00:00") {
      Get.snackbar("Error", "End time cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  //function to add the class and upload it to the database
  //collection name: classes
  //fields: className, startTime, endTime, addedBy, createdAt

  void addClass(String uid, String instructorName) {
    if (!validate()) {
      return;
    }
    loading.value = true;
    //a the class to the list
    classes.add(Course(
      className: classNameController.text,
      startTime: startTimeController.value.text,
      endTime: endTimeController.value.text,
      instructorName: instructorName,
      addedBy: uid,
      createdAt: Timestamp.fromDate(DateTime.now()),
      totalStudents: 0,
    ));

    FirebaseFirestore.instance.collection("classes").add({
      "className": classNameController.text,
      "startTime": startTimeController.value.text,
      "endTime": endTimeController.value.text,
      "addedBy": uid,
      "createdAt": DateTime.now(),
      "instructorName": instructorName,
      "totalStudents": 0,
    }).then((value) {
      Get.snackbar("Success", "Class added successfully",
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
