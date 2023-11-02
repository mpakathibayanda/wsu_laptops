import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/admin/applications/controller/admin_applications_controller.dart';
import 'package:wsu_laptops/admin/applications/views/collecting_view.dart';
import 'package:wsu_laptops/admin/widgets/item.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';

class ApplicationView extends ConsumerStatefulWidget {
  final String studentNumber;
  const ApplicationView({required this.studentNumber, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApplicationViewState();
}

class _ApplicationViewState extends ConsumerState<ApplicationView> {
  final collectionDateTxtCtrl = TextEditingController(text: 'Panding');
  final reseasonDateTxtCtrl = TextEditingController();
  DateTime? date;

  void showAcceptDialog(ApplicationModel app) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext bcontext) {
        return SimpleDialog(
          title: const Text('COLLECTION DATE'),
          children: [
            SimpleDialogOption(
              child: ElevatedButton(
                onPressed: () async {
                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    collectionDateTxtCtrl.text =
                        DateFormat.yMMMMd('en_US').format(date!);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 40,
                  child: TextField(
                    controller: collectionDateTxtCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () async {
                          date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            collectionDateTxtCtrl.text =
                                DateFormat.yMMMMd('en_US').format(date!);
                          }
                        },
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SimpleDialogOption(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  if (date != null) {
                    ApplicationModel application = app.copyWith(
                      status: 'Accepted',
                      collectionDate: date!.millisecondsSinceEpoch.toString(),
                    );
                    Navigator.of(bcontext).pop();
                    ref.watch(applicationControllerProvider).responding(
                          application: application,
                          context: context,
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select collection date'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SimpleDialogOption(
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  collectionDateTxtCtrl.text = 'Pending';
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showRejectDialog(ApplicationModel app) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dcontext) {
        return SimpleDialog(
          title: const Text('REJECTING'),
          children: [
            const SimpleDialogOption(
              child: Text(
                'Are you sure you want to reject this student?',
              ),
            ),
            SimpleDialogOption(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  ApplicationModel application = app.copyWith(
                    status: 'Rejected',
                  );
                  Navigator.of(dcontext).pop();
                  ref.watch(applicationControllerProvider).responding(
                        application: application,
                        context: context,
                      );
                },
                child: const Text(
                  'YES',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SimpleDialogOption(
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  reseasonDateTxtCtrl.clear();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    collectionDateTxtCtrl.dispose();
    reseasonDateTxtCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getApplicationByStudentNumberProvider(widget.studentNumber))
        .when(
          data: (application) {
            var student = application.student!;
            return ref.watch(getLatestApplicationsProvider).when(
              data: (data) {
                final isUpdated = data.events.contains(
                  'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.applicationsCollection}.documents.${application.student!.studentNumber}.update',
                );
                if (isUpdated) {
                  final payload = data.payload;
                  final updatedApplication = ApplicationModel.fromMap(payload);
                  application = updatedApplication.copyWith(
                    student: student,
                  );
                  student = application.student!;
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      '${student.studentNumber}\'s application',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  body: AppBody(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.blueGrey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ItemView(
                              label: 'Name',
                              data: student.name,
                            ),
                            ItemView(
                              label: 'Surname',
                              data: student.surname,
                            ),
                            ItemView(
                              label: 'Funded',
                              data: student.isFunded,
                            ),
                            ItemView(
                              label: 'Status',
                              data: application.status!,
                            ),
                            ItemView(
                              label: 'Brand',
                              data: application.brandName,
                            ),
                            application.status != 'Rejected'
                                ? ItemView(
                                    label: 'Serial number',
                                    data: application.serialNumber ?? 'N/A',
                                  )
                                : const SizedBox(),
                            application.status != 'Rejected'
                                ? ItemView(
                                    label: 'Collection date',
                                    data: dateTime(application.collectionDate ??
                                        'Panding'),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            application.status == 'Submitted'
                                ? OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.black),
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context1) {
                                          return SimpleDialog(
                                            title:
                                                const Text('Changing Status'),
                                            backgroundColor: Colors.blueGrey,
                                            children: [
                                              SimpleDialogOption(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showAcceptDialog(
                                                      application,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: const BorderSide(
                                                        color: Colors.black),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showRejectDialog(
                                                      application,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Reject',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                child: OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: const BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Change Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : application.status == 'Accepted'
                                    ? OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.black),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CollectingView(
                                                    application);
                                              },
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Collecting',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) {
                final Logger logger = Logger();
                logger.e(
                  'ERROR ON LOADING newAPPLICATION',
                  error: error,
                  stackTrace: stackTrace,
                );
                return const ErrorPage(error: 'Error Accured');
              },
              loading: () {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      '${student.studentNumber}\'s application',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  body: AppBody(
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.blueGrey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ItemView(
                              label: 'Name',
                              data: student.name,
                            ),
                            ItemView(
                              label: 'Surname',
                              data: student.surname,
                            ),
                            ItemView(
                              label: 'Funded',
                              data: student.isFunded,
                            ),
                            ItemView(
                              label: 'Status',
                              data: application.status!,
                            ),
                            ItemView(
                              label: 'Brand',
                              data: application.brandName,
                            ),
                            application.status != 'Rejected'
                                ? ItemView(
                                    label: 'Serial number',
                                    data: application.serialNumber ?? 'N/A',
                                  )
                                : const SizedBox(),
                            application.status != 'Rejected'
                                ? ItemView(
                                    label: 'Collection date',
                                    data: dateTime(application.collectionDate ??
                                        'Panding'),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 15),
                            application.status == 'Submitted'
                                ? OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.black),
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context1) {
                                          return SimpleDialog(
                                            title:
                                                const Text('Changing Status'),
                                            backgroundColor: Colors.blueGrey,
                                            children: [
                                              SimpleDialogOption(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showAcceptDialog(
                                                      application,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: const BorderSide(
                                                        color: Colors.black),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showRejectDialog(
                                                        application);
                                                  },
                                                  child: const Text(
                                                    'Reject',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                child: OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: const BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Change Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : application.status == 'Accepted'
                                    ? OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.black),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CollectingView(
                                                    application);
                                              },
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Collecting',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            final Logger logger = Logger();
            logger.e(
              'ERROR ON LOADING APPLICATION',
              error: error,
              stackTrace: stackTrace,
            );
            return const ErrorPage(error: 'Error Accured');
          },
          loading: () => const LoadingPage(),
        );
  }
}
