import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/views/applications_view.dart';

import 'package:wsu_laptops/common/models/admin_model.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';

class AdminHomeView extends ConsumerWidget {
  final String staffNumber;
  const AdminHomeView({
    super.key,
    required this.staffNumber,
  });

  void _logout() {}
  void _applications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ApplicationsView()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AdminModel admin = AdminModel(
      staffNumber: '400123',
      pin: '40012',
      name: 'Joe',
      surname: 'Lucas',
      gender: 'Male',
      role: 'Educational Technologist',
      site: 'Mthatha NMD',
    );
    return Scaffold(
      body: SafeArea(
        child: AppBody(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
}
