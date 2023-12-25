import 'package:attandence_system/Controllers/user_controller.dart';
import 'package:attandence_system/Screens/instructor_home.dart';
import 'package:attandence_system/Screens/student_home.dart';
import 'package:attandence_system/Widgets/custom_textfield.dart';
import 'package:attandence_system/Widgets/login_box.dart';
import 'package:attandence_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance System'),
        centerTitle: true,
      ),
      body: Obx(
        () => loginController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: SvgPicture.asset(
                          'assets/educator-main.svg',
                          height: 200,
                          width: 200,
                        )),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Login as Instructor",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          child: Form(
                            key: loginController.formKey,
                            child: Column(
                              children: [
                                Obx(
                                  () => loginController.isSignup.value
                                      ? CustomTextField(
                                          controller:
                                              loginController.nameController,
                                          icon: Icons.person,
                                          title: "Name",
                                        )
                                      : const SizedBox(),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                    controller: loginController.emailController,
                                    icon: Icons.email,
                                    title: "Email"),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                    controller: loginController.passController,
                                    icon: Icons.lock,
                                    title: "Password"),
                                Obx(() => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          loginController.isSignup.value =
                                              !loginController.isSignup.value;
                                          loginController.formKey.currentState!
                                              .reset();
                                        },
                                        child: loginController.isSignup.value
                                            ? const Text(
                                                "Already have an account? Login Here")
                                            : const Text(
                                                "Don't have an account? Create one here."),
                                      ),
                                    )),
                                Obx(
                                  () => !loginController.isSignup.value
                                      ? InkWell(
                                          onTap: () async {
                                            if (await loginController
                                                .signInWithEmail()) {
                                              loginController.isLoading.value =
                                                  false;
                                              Get.offAll(
                                                  () => const InstructorHome(
                                                        isStudent: false,
                                                      ));
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              //
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: const Center(
                                              child: Text(
                                                "SIGN IN",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            if (await loginController
                                                .creatAndUploadUser()) {
                                              loginController.isLoading.value =
                                                  false;
                                              Get.offAll(
                                                  () => const StudentHome());
                                            } else {
                                              // Get.snackbar(
                                              //     "Error", "Something went wrong");
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: const Center(
                                              child: Text(
                                                "CREATE ACCOUNT",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text("Login as Student"),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                CustomTextField(
                                                    controller:
                                                        loginController.stdpass,
                                                    icon: Icons.lock,
                                                    title: "Password"),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (await loginController
                                                        .studentSignIn()) {
                                                      Get.back();

                                                      // loginController
                                                      //     .isLoading
                                                      //     .value = false;
                                                      Get.offAll(
                                                        () =>
                                                            const InstructorHome(
                                                          isStudent: true,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryColor
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    child: const Center(
                                                      child: Text(
                                                        "Login",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color:
                                                                kPrimaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: const Center(
                                      child: Text(
                                        "Login as Student",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: kPrimaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
