import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/admin/auth/controllers/admin_auth_ctrl.dart';
import 'package:wsu_laptops/admin/auth/views/admin_auth_view.dart';
import 'package:wsu_laptops/admin/home/views/admin_home_view.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';

class AdminRedirectView extends ConsumerWidget {
  const AdminRedirectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentAdminCredProvider).when(
          data: (staffNumber) {
            if (staffNumber != null) {
              return AdminHomeView(staffNumber);
            } else {
              return const AdminAuthView();
            }
          },
          error: (error, stackTrace) {
            Logger logger = Logger();
            logger.e(
              'Error on redirect view',
              error: error,
              stackTrace: stackTrace,
            );
            return ErrorPage(error: error.toString());
          },
          loading: () => const LoadingPage(),
        );
  }
}
