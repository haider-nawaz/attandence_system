import 'dart:ffi';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:attandence_system/Controllers/student_controller.dart';
import 'package:attandence_system/Controllers/user_controller.dart';
import 'package:attandence_system/Screens/classes_screen.dart';
import 'package:attandence_system/Screens/std_screen.dart';
import 'package:attandence_system/Widgets/custom_textfield.dart';
import 'package:attandence_system/constants.dart';
import 'package:attandence_system/models/student.dart';
import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/class_controller.dart';
import '../models/course.dart';

class InstructorHome extends StatelessWidget {
  const InstructorHome({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final classController = Get.put(ClassController());
    final stdController = Get.put(StudentController());

    //if dark mode is on
    Border border = AdaptiveTheme.of(context).mode.isDark
        ? const Border.fromBorderSide(BorderSide.none)
        : Border.all(color: Colors.black);

    Get.put(UserController());
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //give max width and 20% height
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimaryColor,
                    //kPrimaryColor.withOpacity(0.4),
                    AdaptiveTheme.of(context).mode.isDark
                        ? Colors.black
                        : Colors.white.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Obx(
                  () => userController.isUserLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${userController.greet()},",
                                    style: GoogleFonts.poppins(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          //toggle between dark and light mode
                                          if (AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark ==
                                              true) {
                                            AdaptiveTheme.of(context)
                                                .setLight();
                                          } else {
                                            AdaptiveTheme.of(context).setDark();
                                          }
                                        },
                                        icon: AdaptiveTheme.of(context)
                                                    .mode
                                                    .isDark ==
                                                true
                                            ? const Icon(
                                                CupertinoIcons.moon_fill,
                                                size: 25,
                                                color: Colors.blueAccent,
                                              )
                                            : const Icon(
                                                CupertinoIcons.sun_max_fill,
                                                size: 25,
                                                color: Colors.yellow,
                                              ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          //open a cupertino style bottom sheet
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoActionSheet(
                                              title: Text(
                                                userController.isUserInstructor
                                                    ? "Instructor"
                                                    : "Student",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              message: Text(
                                                "Name: ${userController.userName}\nEmail: ${userController.userEmail}",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              actions: [
                                                CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    //sign out the user
                                                    userController.signOut();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Sign Out"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.profile_circled,
                                          size: 30,
                                          color: Colors.black,
                                        ),
                                      ),
                                      //a switch to toggle between dark and light mode
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                userController.userName,
                                style: GoogleFonts.poppins(
                                    fontSize: 50, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),

            //the rest 80% of the screen

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text("Quick Insights",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => StudentScreen(
                          stds: stdController.students,
                        )),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: border),
                      child: Center(
                        child: ListTile(
                          // leading: const Icon(Icons.class_),
                          title: Text(
                            stdController.students.length.toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 40, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text("Enrolled Students",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => ClassesScreen(
                          classes: classController.classes,
                        )),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: border),
                      child: Center(
                        child: ListTile(
                          // leading: const Icon(Icons.class_),
                          title: Text(
                            classController.classes.length.toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 40, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text("Active Classes",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text("Quick Actions",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCupertinoModalSheet(
                            context: context,
                            builder: (context) => dialogAddStudents(
                              stdController,
                              classController.classes,
                              userController.userUid,
                              userController.userName,
                              context,
                              border,
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: border),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/std.png",
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  "Add Students",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          //open a cupertino style bottom sheet
                          showCupertinoModalSheet(
                            context: context,
                            builder: (context) => dialogAddClasses(
                              classController,
                              userController.userUid,
                              userController.userName,
                              context,
                              border,
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: border),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/classroom.png",
                                  height: 60,
                                  width: 60,
                                ),
                                Text(
                                  "Add Class",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dialogAddClasses(ClassController controller, String uid,
      String instructorName, BuildContext context, Border border) {
    //a dialog box to add classes
    // will have 3 text fields, 1 for name, 1 for class start time and 1 for class end time
    return Material(
      child: Container(
        // height: Get.size.height * 0.5,
        //width: Get.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Class/Course",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                  controller: controller.classNameController,
                  icon: Icons.abc,
                  title: "Class Name"),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text("Start Time", style: TextStyle(fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("tapped");
                          //open a time picker and set the time in the controller
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            print("Value: $value");
                            controller.startTimeController.value.text =
                                value!.format(context);

                            print(controller.startTimeController.value.text);
                          });
                        },
                        child: Container(
                          // a container to show the time. initially it will show start time and it will show the time selected by the user
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(50),
                              border: border),
                          child: Center(
                            child: GetBuilder(
                              init: controller,
                              builder: (controller) => Text(
                                controller.startTimeController.value.text,
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      const Text("End Time", style: TextStyle(fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("tapped");
                          //open a time picker and set the time in the controller
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            print("Value: $value");
                            controller.endTimeController.value.text =
                                value!.format(context);

                            print(controller.startTimeController.value.text);
                            //refresh the controller
                            controller.update();
                          });
                        },
                        child: Container(
                          // a container to show the time. initially it will show start time and it will show the time selected by the user
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(50),
                              border: border),
                          child: Center(
                            child: GetBuilder(
                              init: controller,
                              builder: (controller) => Text(
                                controller.endTimeController.value.text,
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              // a row of 2 buttons, 1 to cancel and 1 to add the class
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() => controller.loading.value
                      ? const CircularProgressIndicator(
                          color: kPrimaryColor,
                        )
                      : GestureDetector(
                          onTap: () {
                            controller.addClass(uid, instructorName);
                          },
                          child: Container(
                            height: 50,
                            width: Get.size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: border,
                            ),
                            child: Center(
                              child: Text(
                                "Add",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
                  GestureDetector(
                    onTap: () {
                      //add the class
                      controller.reset();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: Get.size.width * 0.3,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: border,
                      ),
                      child: Center(
                        child: Text(
                          "Done",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  dialogAddStudents(StudentController stdController, List<Course> courses,
      String userUid, String userName, BuildContext context, Border border) {
    //a dialog box to add students
    // will have 1 text field, 1 for student email
    return Material(
      child: Container(
        // height: Get.size.height * 0.5,
        //width: Get.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Student",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                  controller: stdController.studentNameController,
                  icon: Icons.abc,
                  title: "Student Name"),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: stdController.studentIDController,
                  icon: Icons.abc,
                  title: "Student ID"),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: stdController.studentPasswordController,
                  icon: Icons.abc,
                  title: "Student Password"),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select Classes",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                    displayClassesWidget(courses),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              // a row of 2 buttons, 1 to cancel and 1 to add the class
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() => stdController.loading.value
                      ? const CircularProgressIndicator(
                          color: kPrimaryColor,
                        )
                      : GestureDetector(
                          onTap: () {
                            stdController.addStudent(userUid, userName);
                          },
                          child: Container(
                            height: 50,
                            width: Get.size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: border,
                            ),
                            child: Center(
                              child: Text(
                                "Add",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
                  GestureDetector(
                    onTap: () {
                      //add the class
                      stdController.reset();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: Get.size.width * 0.3,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: border,
                      ),
                      child: Center(
                        child: Text(
                          "Done",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  displayClassesWidget(List<Course> courses) {
    //diplay chips of classes and chips will be clickable
    return GetBuilder(
      init: StudentController(),
      builder: (controller) => Wrap(
        spacing: 10,
        children: List.generate(
          courses.length,
          (index) => GestureDetector(
            onTap: () {
              if (controller.selectedClasses
                  .contains(courses[index].className)) {
                controller.selectedClasses.remove(courses[index].className);
              } else {
                controller.selectedClasses.add(courses[index].className);
              }
            },
            child: Obx(() => Chip(
                  label: Text(
                    courses[index].className,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: controller.selectedClasses
                          .contains(courses[index].className)
                      ? kPrimaryColor
                      : Colors.grey.withOpacity(0.5),
                )),
          ),
        ),
      ),
    );
  }
}
