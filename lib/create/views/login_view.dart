import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/create/controllers/auth_controller.dart';

class AddLoginView extends ConsumerWidget {
  const AddLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(addAuthProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              ctrl.login(context);
            },
            child: const Text('Login'),
          ),
        ),
      ),
    );
  }
}
