import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wsu_laptops/admin/applications/controller/applications_controller.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';

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

  void showAcceptDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          title: const Text('COLLECTION DATE'),
          children: [
            SimpleDialogOption(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showAcceptDialog();
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
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            collectionDateTxtCtrl.text =
                                DateFormat.yMMMMd('en_US').format(date);
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
                  Navigator.of(context).pop();
                  //TODO : On done accepting
                  collectionDateTxtCtrl.text = 'Pending';
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

  void showRejectDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          title: const Text('REJECTING'),
          children: [
            SimpleDialogOption(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showAcceptDialog();
                },
                child: Container(
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  height: 40,
                  child: TextField(
                    controller: reseasonDateTxtCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Rejection reason',
                      contentPadding: EdgeInsets.all(8),
                      border: InputBorder.none,
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
                  Navigator.of(context).pop();
                  //TODO : On done rejecting
                  reseasonDateTxtCtrl.clear();
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
    final application = ref.watch(
      getApplicationByStudentNumberProvider(widget.studentNumber),
    );
    final student = application.student!;
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
                ItemView(
                  label: 'Serial number',
                  data: application.serialNumber ?? 'N/A',
                ),
                ItemView(
                  label: 'Collection date',
                  data: dateTime(application.collectionDate ?? 'Panding'),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text('Changing Status'),
                          backgroundColor: Colors.blueGrey,
                          children: [
                            SimpleDialogOption(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showAcceptDialog();
                                },
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SimpleDialogOption(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(color: Colors.black),
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showRejectDialog();
                                },
                                child: const Text(
                                  'Reject',
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
                  },
                  child: const Text(
                    'Change Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  const ItemView({
    super.key,
    required this.label,
    required this.data,
  });

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
