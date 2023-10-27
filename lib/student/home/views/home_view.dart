import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/student/home/views/student_view.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/controllers/home_controller.dart';

class HomeView extends ConsumerStatefulWidget {
  final String studentNumber;
  const HomeView({required this.studentNumber, super.key});
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
    return ref.watch(getStudentDataProvider(widget.studentNumber)).when(
          data: (student) {
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
                            child: StudentView(student),
                          ),
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 20,
                              ),
                            ),
                            onPressed: _logout,
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrac) => ErrorPage(
            error: error.toString(),
          ),
          loading: () => const LoadingPage(),
        );
  }
}
