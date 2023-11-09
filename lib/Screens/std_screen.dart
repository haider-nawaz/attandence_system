import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:attandence_system/models/student.dart';
import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  final List<Student> stds;

  const StudentScreen({super.key, required this.stds});

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
              itemCount: stds.length,
              itemBuilder: (context, index) {
                final std = stds[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: studentWidget(std, context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  studentWidget(Student std, BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: AdaptiveTheme.of(context).mode.isDark
            ? const BorderSide(color: Colors.white)
            : const BorderSide(color: Colors.black),
      ),
      title: Text(
        std.name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        std.id,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }
}
