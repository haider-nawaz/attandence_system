import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/course.dart';

class ClassesScreen extends StatelessWidget {
  final List<Course> classes;
  const ClassesScreen({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classes"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final course = classes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CourseWidget(course: course),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CourseWidget extends StatelessWidget {
  const CourseWidget({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: AdaptiveTheme.of(context).mode.isDark
            ? const BorderSide(color: Colors.white)
            : const BorderSide(color: Colors.black),
      ),
      title: Text(
        course.className,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        "Instructor: ${course.instructorName}",
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 5),
              Text(
                "${course.startTime} - ${course.endTime}",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     const Icon(Icons.person),
          //     const SizedBox(width: 3),
          //     Text(
          //       "${course.totalStudents}",
          //       style: GoogleFonts.poppins(
          //         fontSize: 12,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
