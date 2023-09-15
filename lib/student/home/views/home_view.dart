import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';
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
  @override
  Widget build(BuildContext context) {
    return ref.watch(studentDataProvider).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: Container(
                  color: Colors.white,
                  width: 50,
                  child: Image.asset(
                    'assets/wsu.png',
                  ),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                txt: 'Student number',
                                value: data.studentNumber,
                                color: Colors.grey,
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
                              const TileTxt(
                                txt: 'Collection date',
                                value: '20 May 2023',
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                          child: const Text('APPLICATION INFO'),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('MAINTAINANCE'),
                                        ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('LOGOUT'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorPage(
            error: error.toString(),
          ),
          loading: () => const LoadingPage(),
        );
  }
}
