import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';
import 'package:wsu_laptops/student/applications/controllers/application_ctrl.dart';
import 'package:wsu_laptops/student/home/views/home_view.dart';
import 'package:wsu_laptops/student/home/views/not_applied_view.dart';

class StudentApplication extends ConsumerStatefulWidget {
  final StudentModel student;
  final List<String> items;
  const StudentApplication(this.student, this.items, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends ConsumerState<StudentApplication> {
  bool cancel = false;
  String dropdownvalue = 'SELECT BRAND';

  void _onSubmit({required ApplicationModel application}) {
    ref.watch(applicationControllerProvider.notifier).submitApp(
          context: context,
          application: application,
        );
  }

  void _onCancel(bool isCanceling) {
    cancel = true;
    if (isCanceling) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NotAppliedView(student: widget.student),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('You want to cancel this application?'),
              actions: [
                OutlinedButton(
                  onPressed: () => _onCancel(true),
                  child: const Text('YES'),
                ),
                ElevatedButton(
                  onPressed: () => _onCancel(false),
                  child: const Text('NO'),
                )
              ],
            );
          },
        );
        return cancel;
      },
      child: Scaffold(
        body: SafeArea(
          child: AppBody(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                    'You want to cancel this application?'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeView(
                                              widget.student.studentNumber),
                                        ),
                                      );
                                      cancel = true;
                                    },
                                    child: const Text('YES'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      cancel = false;
                                    },
                                    child: const Text('NO'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Image.asset(
                      'assets/wsu.png',
                    ),
                    const Center(
                      child: Text(
                        'LAPTOP APPLICATIONS FORM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TileTxt(
                      txt: 'Name: ',
                      value: widget.student.name,
                      color: Colors.grey,
                    ),
                    TileTxt(
                      txt: 'Surname: ',
                      value: widget.student.surname,
                      color: Colors.grey,
                    ),
                    TileTxt(
                      txt: 'Student number: ',
                      value: widget.student.studentNumber,
                      color: Colors.grey,
                    ),
                    TileTxt(
                      txt: 'Qualification: ',
                      value: widget.student.qualification,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Brand: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButton(
                              value: dropdownvalue,
                              dropdownColor: Colors.blueAccent,
                              items: widget.items
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          color: e == 'SELECT BRAND'
                                              ? Colors.red
                                              : null,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropdownvalue = value ?? 'LENOVO';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 20,
                      child: ElevatedButton(
                        onPressed: () {
                          if (dropdownvalue != 'SELECT BRAND') {
                            ApplicationModel application = ApplicationModel(
                              student: widget.student,
                              brandName: dropdownvalue,
                              isFunded: widget.student.isFunded,
                              status: 'Submitted',
                              date: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                            );
                            _onSubmit(application: application);
                          } else {
                            showErrorDialog(
                              context: context,
                              error: 'Please Select brand',
                            );
                          }
                        },
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
