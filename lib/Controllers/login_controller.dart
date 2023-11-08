import 'package:attandence_system/Controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isSignup = false.obs;

  final emailController = TextEditingController();
  final passController = TextEditingController();
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
}
