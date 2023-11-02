import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/controllers/home_controller.dart';
import 'package:wsu_laptops/student/home/views/not_applied_view.dart';

class AppliedView extends ConsumerWidget {
  final String studentNumber;
  const AppliedView({super.key, required this.studentNumber});

  void delete(BuildContext context, WidgetRef ref) {
    ref.watch(homeControllerProvider.notifier).deleteApplication(
          context,
          studentNumber: studentNumber,
        );
  }

  void onDeleteApplication(BuildContext context1, WidgetRef ref) {
    showDialog(
      context: context1,
      barrierColor: const Color.fromARGB(94, 252, 63, 49),
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: const Text('Are you sure you to DELETE this application'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                delete(context1, ref);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Logger logger = Logger();
    return ref.watch(getApplicationProvider(studentNumber)).when(
          data: (application) {
            return ref.watch(getLastestStudentDataProvider(studentNumber)).when(
              data: (data) {
                var student = application.student!;
                bool deleteEvent = data.events.contains(
                    'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.applicationsCollection}.documents.${application.studentNumber}.delete');

                if (!deleteEvent) {
                  if (data.payload.containsKey('studentNumber')) {
                    application = ApplicationModel.fromMap(data.payload);
                    student = application.student!;
                  }
                }

                if (deleteEvent) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'WELCOME ${student.name} ${student.surname}'
                            .toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text('Your application has been deleted'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotAppliedPage(
                                student: student,
                              ),
                            ),
                          );
                        },
                        child: const Text('Re-Apply'),
                      ),
                    ],
                  );
                } else {
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            SizedBox(
                              height:
                                  application.status == 'Submitted' ? 20 : 0,
                            ),
                            Visibility(
                              visible: application.status == 'Submitted',
                              replacement: const SizedBox(height: 20),
                              child: OutlinedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 20,
                                  ),
                                ),
                                onPressed: () =>
                                    onDeleteApplication(context, ref),
                                child: const Text('Delete'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          SizedBox(
                            height: application.status == 'Submitted' ? 20 : 0,
                          ),
                          Visibility(
                            visible: application.status == 'Submitted',
                            replacement: const SizedBox(height: 20),
                            child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 20,
                                ),
                              ),
                              onPressed: () =>
                                  onDeleteApplication(context, ref),
                              child: const Text('Delete'),
                            ),
                          )
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: AppliedView(
                      studentNumber: studentNumber,
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
