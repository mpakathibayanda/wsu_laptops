import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
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
    return ref
        .watch(getApplicationByIdProvider(widget.student.studentNumber))
        .when(
          data: (application) {
            if (application != null) {
              return AppliedView(
                studentNumber: widget.student.studentNumber,
              );
            } else {
              return NotAppliedView(student: widget.student);
            }
          },
          error: (error, stackTrace) {
            logger.i(
              'Error on get application',
              error: error,
              stackTrace: stackTrace,
            );
            return ErrorText(error: error.toString());
          },
          loading: () => const Loading(),
        );
  }
}
