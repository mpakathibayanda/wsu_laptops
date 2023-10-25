import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/laptops/view/laptops_view.dart';

class NotAppliedView extends ConsumerWidget {
  final StudentModel student;
  const NotAppliedView({super.key, required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'WELCOME ${student.name} ${student.surname}'.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        LaptopsView(student: student),
      ],
    );
  }
}
