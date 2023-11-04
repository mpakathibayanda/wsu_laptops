import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/controller/admin_applications_controller.dart';
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
                final isUpdate = data.events.contains(
                  'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.applicationsCollection}.documents.*.update',
                );
                final isCreate = data.events.contains(
                  'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.applicationsCollection}.documents.*.create',
                );
                final isDelete = data.events.contains(
                  'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.applicationsCollection}.documents.*.delete',
                );
                final any = isCreate || isUpdate || isDelete;
                if (any) {
                  if (isUpdate) {
                    var updatedApp = ApplicationModel.fromMap(data.payload);
                    final i = applications.indexWhere(
                      (app) => app.studentNumber == updatedApp.studentNumber,
                    );
                    applications[i] = updatedApp;
                  }
                  if (isCreate) {
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
                  if (isDelete) {
                    final deleted = ApplicationModel.fromMap(data.payload);
                    applications.removeWhere(
                      (app) => deleted.studentNumber == app.studentNumber,
                    );
                  }
                }
                return applications.isNotEmpty
                    ? Scaffold(
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (context, index) {
                                return ApplicationItem(
                                  application: applications[index],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Scaffold(
                        appBar: AppBar(),
                        body: const Center(
                          child: Text('NO APPLICATIONS'),
                        ),
                      );
              },
              error: (error, stackTrace) {
                return const ErrorPage(error: 'Something went wrong');
              },
              loading: () {
                return applications.isNotEmpty
                    ? Scaffold(
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
                      )
                    : Scaffold(
                        appBar: AppBar(),
                        body: const Center(
                          child: Text('NO APPLICATIONS'),
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
