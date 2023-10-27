import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/views/applications_view.dart';
import 'package:wsu_laptops/admin/auth/views/admin_auth_view.dart';
import 'package:wsu_laptops/admin/home/controller/admin_home_ctrl.dart';

import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';

class AdminHomeView extends ConsumerStatefulWidget {
  final String staffNumber;
  const AdminHomeView(this.staffNumber, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends ConsumerState<AdminHomeView> {
  void _logout() {
    final res = ref.watch(adminControllerProvider.notifier);
    res.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const AdminAuthView(),
      ),
    );
  }

  bool isLoad = false;
  void _applications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ApplicationsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.watch(adminControllerProvider.notifier).getUserData(
            staffNumber: widget.staffNumber,
          ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final admin = snapshot.data!;
          return Scaffold(
            body: SafeArea(
              child: AppBody(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                            'ADMINISTRACTOR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 100,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TileTxt(
                                  txt: 'Name',
                                  value: admin.name,
                                  color: Colors.grey,
                                ),
                                TileTxt(
                                  txt: 'Surname',
                                  value: admin.surname,
                                ),
                                TileTxt(
                                  txt: 'Staff number',
                                  value: admin.staffNumber,
                                  color: Colors.grey,
                                ),
                                TileTxt(
                                  txt: 'Gender',
                                  value: admin.gender,
                                ),
                                TileTxt(
                                  txt: 'Role',
                                  value: admin.role,
                                  color: Colors.grey,
                                ),
                                TileTxt(
                                  txt: 'Site',
                                  value: admin.site,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _applications(context),
                                child: const Text(
                                  'APPLICATIONS',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _logout,
                                child: const Text('LOGOUT'),
                              ),
                            ),
                          ],
                        ),
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
        return const ErrorPage(error: 'Something went wrong');
      },
    );
  }
}
