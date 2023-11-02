import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/laptops/view/laptops_view.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/controllers/home_controller.dart';

class NotAppliedView extends ConsumerWidget {
  final StudentModel student;
  const NotAppliedView({super.key, required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
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

class NotAppliedPage extends StatelessWidget {
  final StudentModel student;
  const NotAppliedPage({required this.student, super.key});

  void _logout(BuildContext context, WidgetRef ref) {
    final res = ref.watch(homeControllerProvider.notifier);
    res.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const AuthView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WSU LAPTOP APPLICATIONS'),
      ),
      body: SafeArea(
        child: AppBody(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: NotAppliedView(
                      student: student,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(),
                        ),
                        onPressed: () => _logout(context, ref),
                        child: const Text('Logout'),
                      );
                    },
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
