import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/student/auth/controllers/auth_controller.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/views/home_view.dart';

class StudentRedirectView extends ConsumerWidget {
  const StudentRedirectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserCredProvider).when(
          data: (studentNumber) {
            if (studentNumber != null) {
              return HomeView(studentNumber: studentNumber);
            } else {
              return const AuthView();
            }
          },
          error: (error, stackTrace) {
            Logger logger = Logger();
            logger.e(
              'Error on redirect view',
              error: error,
              stackTrace: stackTrace,
            );
            return ErrorPage(error: error.toString());
          },
          loading: () => const LoadingPage(),
        );
  }
}
