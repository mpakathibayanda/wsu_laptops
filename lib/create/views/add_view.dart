import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/create/controllers/add_controller.dart';

class AddView extends ConsumerWidget {
  const AddView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(addControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => ctrl.addStudents(context),
            child: const Text('Add Students'),
          ),
        ),
      ),
    );
  }
}
