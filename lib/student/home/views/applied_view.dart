import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/controllers/home_controller.dart';

class AppliedView extends ConsumerWidget {
  final String studentNumber;
  const AppliedView({super.key, required this.studentNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Logger logger = Logger();
    return ref.watch(getApplicationProvider(studentNumber)).when(
          data: (application) {
            return ref.watch(getLastestStudentDataProvider(studentNumber)).when(
              data: (data) {
                logger.i(
                  'PAYLOAD: ${data.payload}',
                );
                logger.i(
                  'EVENTS: ${data.events}',
                );
                var student = application.student!;
                if (data.payload.containsKey('status')) {
                  application = ApplicationModel.fromMap(data.payload);
                  application = application.copyWith(student: student);
                }
                if (data.payload.containsKey('qualification')) {
                  student = StudentModel.fromMap(data.payload);
                }
                if (data.payload.containsKey('student')) {
                  application = ApplicationModel.fromMap(data.payload);
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME ${student.name} ${student.surname}'
                          .toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('APPLICATION INFO'),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8, top: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TileTxt(
                            txt: 'Brand Name',
                            value: application.brandName,
                            color: Colors.grey,
                          ),
                          TileTxt(
                            txt: 'Serial Number',
                            value: application.serialNumber,
                          ),
                          TileTxt(
                            txt: 'Status',
                            value: application.status,
                            color: Colors.grey,
                          ),
                          TileTxt(
                            txt: 'Application Date',
                            value: dateTime(application.date),
                          ),
                          TileTxt(
                            txt: 'Collecation Date',
                            value: dateTime(
                                application.collectionDate ?? 'Pending'),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
                logger.e(
                  'Error on get user data',
                  error: error,
                  stackTrace: stackTrace,
                );
                return const ErrorText(
                  error: 'UNKOWN ERROR?TRY TO RESTART THE APP',
                );
              },
              loading: () {
                var student = application.student!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME ${student.name} ${student.surname}'
                          .toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('APPLICATION INFO'),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8, top: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TileTxt(
                            txt: 'Brand Name',
                            value: application.brandName,
                            color: Colors.grey,
                          ),
                          TileTxt(
                            txt: 'Serial Number',
                            value: application.serialNumber,
                          ),
                          TileTxt(
                            txt: 'Status',
                            value: application.status,
                            color: Colors.grey,
                          ),
                          TileTxt(
                            txt: 'Application Date',
                            value: dateTime(application.date),
                          ),
                          TileTxt(
                            txt: 'Collecation Date',
                            value: dateTime(
                                application.collectionDate ?? 'Pending'),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
          error: (error, stackTrace) {
            logger.e(
              'Error on get user data: ${error.toString()}',
              error: error,
              stackTrace: stackTrace,
            );
            return const ErrorText(
              error: 'UNKOWN ERROR?TRY TO RESTART THE APP',
            );
          },
          loading: () => const Loading(),
        );
  }
}

class AppliedPage extends StatelessWidget {
  final String studentNumber;
  const AppliedPage({required this.studentNumber, super.key});
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
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: AppliedView(
                      studentNumber: studentNumber,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 20,
                          ),
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
