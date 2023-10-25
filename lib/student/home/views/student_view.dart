import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/student/applications/controllers/application_ctrl.dart';
import 'package:wsu_laptops/student/home/views/applied_view.dart';
import 'package:wsu_laptops/student/home/views/not_applied_view.dart';

class StudentView extends ConsumerStatefulWidget {
  final StudentModel student;
  const StudentView(this.student, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentView();
}

class _StudentView extends ConsumerState<StudentView> {
  Logger logger = Logger();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref
          .watch(applicationControllerProvider.notifier)
          .getApplicationById(id: widget.student.studentNumber),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var application = snapshot.data;
          if (application != null) {
            return AppliedView(
              application: application,
              student: widget.student,
            );
          } else {
            return NotAppliedView(student: widget.student);
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading...'));
        }
        return NotAppliedView(student: widget.student);
      },
    );
  }
}
