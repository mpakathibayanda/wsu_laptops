import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/controller/applications_controller.dart';
import 'package:wsu_laptops/admin/widgets/application_item.dart';

class AppSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  AppSearchDelegate(this.ref);
  @override
  String? get searchFieldLabel => 'Student number';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchApplicationsProvider(query)).when(
          data: (apps) {
            return ListView.builder(
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return ApplicationItem(application: app);
              },
            );
          },
          error: (error, stackTrace) {
            return const Text('Something went wrong');
          },
          loading: () => const SizedBox(),
        );
  }
}
