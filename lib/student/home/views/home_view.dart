import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/dropdown.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/controllers/home_controller.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  void _logout() {
    final res = ref.watch(homeControllerProvider.notifier);
    res.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const AuthView(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(studentDataProvider).when(
          data: (data) {
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
                          ),
                          const Center(
                            child: Text(
                              'LAPTOP APPLICATIONS',
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
                                      '${data.name}, ${data.surname}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TileTxt(
                                    txt: 'Gender',
                                    value: data.gender,
                                    color: Colors.grey,
                                  ),
                                  TileTxt(
                                    txt: 'Student number',
                                    value: data.studentNumber,
                                  ),
                                  TileTxt(
                                    txt: 'Department',
                                    value: data.department,
                                    color: Colors.grey,
                                  ),
                                  TileTxt(
                                    txt: 'Course',
                                    value: data.course,
                                  ),
                                  TileTxt(
                                    txt: 'Funded',
                                    value: data.isFunded,
                                    color: Colors.grey,
                                  ),
                                  TileTxt(
                                    txt: 'Status',
                                    value: data.status,
                                  ),
                                  TileTxt(
                                    txt: 'Collection date',
                                    value: data.collectionDate,
                                    color: Colors.grey,
                                  ),
                                  AppDropdown(
                                    title: 'Laptop info',
                                    laptopInfo: data.laptopModel,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          data.status == 'Not Applied'
                              ? ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('APPLY NOW'),
                                )
                              : data.status == 'Padding payment'
                                  ? ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('HOW TO PAY'),
                                    )
                                  : data.status == 'Not Collected'
                                      ? ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('HOW TO COLLECT'),
                                        )
                                      : data.status == 'Submitted'
                                          ? ElevatedButton(
                                              onPressed: () {},
                                              child: const Text(
                                                  'APPLICATION INFO'),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {},
                                              child: const Text('MAINTAINANCE'),
                                            ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: _logout,
                            child: const Text('LOGOUT'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            print('[ERROR]: ${error.toString()}');
            print('[STACKTRACK]: ${stackTrace.toString()}');
            return ErrorPage(
              error: error.toString(),
            );
          },
          loading: () => const LoadingPage(),
        );
  }
}
