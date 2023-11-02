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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => ctrl.addStudents(context),
                  child: const Text('Add Students'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => ctrl.addLaptops(context),
                  child: const Text('Add Laptops'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => ctrl.addAdmins(context),
                  child: const Text('Add Admins'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
