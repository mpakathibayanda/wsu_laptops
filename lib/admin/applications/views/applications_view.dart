import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/controller/applications_controller.dart';
import 'package:wsu_laptops/admin/widgets/application_item.dart';
import 'package:wsu_laptops/admin/widgets/search_delegate.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';

class ApplicationsView extends ConsumerStatefulWidget {
  const ApplicationsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApplicationsViewState();
}

class _ApplicationsViewState extends ConsumerState<ApplicationsView> {
  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(getAllApplicationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Applications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showSearch(
                context: context,
                delegate: AppSearchDelegate(ref),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search application by student number or a name',
          ),
        ],
      ),
      body: SafeArea(
        child: AppBody(
          color: Colors.white,
          child: ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              return ApplicationItem(
                application: applications[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
