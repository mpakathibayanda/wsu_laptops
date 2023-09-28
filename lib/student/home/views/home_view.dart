import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/dropdown.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';
import 'package:wsu_laptops/student/applications/views/app_view.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/controllers/home_controller.dart';

class HomeView extends ConsumerStatefulWidget {
  final String student;
  const HomeView(this.student, {super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  void _logout() {
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
    return FutureBuilder<StudentModel>(
      future: ref.watch(getUserDataProvider(widget.student).future),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final student = snapshot.data!;
          return Scaffold(
            body: SafeArea(
              child: AppBody(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/wsu.png',
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                        ),
                        const Center(
                          child: Text(
                            ' WSU LAPTOP APPLICATIONS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Card(
                          elevation: 100,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Text(
                                    '${student.name}, ${student.surname}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TileTxt(
                                  txt: 'Gender',
                                  value: student.gender,
                                  color: Colors.grey,
                                ),
                                TileTxt(
                                  txt: 'Student number',
                                  value: student.studentNumber,
                                ),
                                TileTxt(
                                  txt: 'Department',
                                  value: student.department,
                                  color: Colors.grey,
                                ),
                                TileTxt(
                                  txt: 'Course',
                                  value: student.course,
                                ),
                                TileTxt(
                                  txt: 'Funded',
                                  value: student.isFunded,
                                  color: Colors.grey,
                                ),
                                TileTxt(
                                  txt: 'Status',
                                  value: student.status,
                                ),
                                TileTxt(
                                  txt: 'Collection date',
                                  value: student.collectionDate,
                                  color: Colors.grey,
                                ),
                                Visibility(
                                  visible: student.status != 'Not Applied',
                                  child: Builder(builder: (context) {
                                    return AppDropdown(
                                      student.studentNumber,
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Visibility(
                          visible: student.status == 'Not Applied',
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Application(student),
                                ),
                              );
                            },
                            child: const Text('APPLY NOW'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: _logout,
                          child: const Text('LOGOUT'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }
        return ErrorPage(error: snapshot.error.toString());
      },
    );
  }
}
