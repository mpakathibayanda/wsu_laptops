import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/create/controllers/auth_controller.dart';
import 'package:wsu_laptops/create/views/add_view.dart';
import 'package:wsu_laptops/create/views/login_view.dart';

class AddRedictPage extends ConsumerWidget {
  const AddRedictPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(addAuthProvider);
    return FutureBuilder(
      future: ctrl.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null) {
            if (data) {
              return const AddView();
            } else {
              return const AddLoginView();
            }
          } else {
            return const AddLoginView();
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }
        return ErrorPage(error: snapshot.error.toString());
      },
    );
  }
}
