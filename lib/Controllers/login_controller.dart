import 'package:attandence_system/Controllers/user_controller.dart';
import 'package:attandence_system/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isSignup = false.obs;

  // a single instance of current logged in student
  final currStudent = Rxn<Student>();

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final stdpass = TextEditingController();
  final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validateInputs() {
    if (formKey.currentState!.validate()) {
      print("Validated");
      return true;
    } else {
      print("Not Validated");
      return false;
    }
  }

  Future<bool> creatAndUploadUser() async {
    if (!validateInputs()) {
      return false;
    }

    isLoading.value = true;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.toString().trim(),
            password: passController.text.toString().trim())
        .then((value) async {
      print("User Created");
      //upload the user in the instructors collection
      await FirebaseFirestore.instance
          .collection("instructors")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "name": nameController.text.toString().trim(),
        "email": emailController.text.toString().trim(),
        "uid": value.user!.uid,
        "isInstructor": true,
        "createdAt": DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value) {
        print("User Uploaded");
        //sign in the user
        FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.toString().trim(),
            password: passController.text.toString().trim());

        print("User Signed In");
        isLoading.value = false;
        return true;
      });
    });
    return false;
  }

  Future<bool> signInWithEmail() async {
    // final userController = Get.put(UserController());

    if (!validateInputs()) {
      return false;
    }

    isLoading.value = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.toString().trim(),
        password: passController.text.toString().trim(),
      );

      print("User Signed In");

      // isLoading.value = false;
      await Get.find<UserController>().getCurrentUserDetails();
      return true;
    } catch (e) {
      print("Error signing in: $e");
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> studentSignIn() {
    if (stdpass.text.isEmpty) {
      return Future.value(false);
    }

    isLoading.value = true;

    return FirebaseFirestore.instance
        .collection("students")
        .where("password", isEqualTo: stdpass.text.toString().trim())
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        stdpass.clear();
        print("Student Signed In");
        currStudent.value = Student.fromMap(value.docs.first.data());
        print(currStudent.value!.name);

        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    });
  }
}
