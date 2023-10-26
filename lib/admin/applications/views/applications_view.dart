import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/controller/applications_controller.dart';
import 'package:wsu_laptops/admin/widgets/application_item.dart';
import 'package:wsu_laptops/admin/widgets/search_delegate.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';

class ApplicationsView extends ConsumerStatefulWidget {
  const ApplicationsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApplicationsViewState();
}

class _ApplicationsViewState extends ConsumerState<ApplicationsView> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getAllApplicationsProvider).when(
          data: (applications) {
            return ref.watch(getLatestApplicationsProvider).when(
              data: (data) {
                final isUpdated = data.events.contains(
                  'databases.${AppwriteConstants.applicationsDatabaseId}.collections.${AppwriteConstants.applicationCollection}.documents.*.update',
                );
                final isCreated = data.events.contains(
                  'databases.${AppwriteConstants.applicationsDatabaseId}.collections.${AppwriteConstants.applicationCollection}.documents.*.create',
                );
                if (isUpdated || isCreated) {
                  if (isUpdated) {
                    var updatedApp = ApplicationModel.fromMap(data.payload);
                    final i = applications.indexWhere(
                      (app) => app.studentNumber == updatedApp.studentNumber,
                    );
                    var newApp = updatedApp.copyWith(
                      student: applications[i].student,
                    );
                    applications[i] = newApp;
                  }
                  if (isCreated) {
                    final newApp = ref
                        .watch(
                          getApplicationProvider(
                            data.payload['studentNumber'],
                          ),
                        )
                        .value;
                    if (newApp != null) {
                      applications.add(newApp);
                    }
                  }
                }
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
                        tooltip:
                            'Search application by student number or a name',
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
              },
              error: (error, stackTrace) {
                return const ErrorPage(error: 'Something went wrong');
              },
              loading: () {
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
                        tooltip:
                            'Search application by student number or a name',
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
              },
            );
          },
          error: (error, stackTrace) {
            return const ErrorPage(error: 'Something went wrong');
          },
          loading: () => const LoadingPage(),
        );
  }
}
