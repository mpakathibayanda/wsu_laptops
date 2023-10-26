import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/admin/applications/api/applications_api.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';

final applicationControllerProvider = StateProvider((ref) {
  return ApplicationsController(
    applicationsApi: ref.watch(adminApplicationsApiProvider),
  );
});

final getAllApplicationsProvider = FutureProvider((ref) {
  final appCtr = ref.watch(applicationControllerProvider);
  return appCtr.getApplications();
});

final searchApplicationsProvider = FutureProvider.family((ref, String query) {
  final appCtr = ref.watch(applicationControllerProvider);
  return appCtr.searchApplications(query: query);
});

final getApplicationByStudentNumberProvider =
    FutureProvider.family((ref, String studentNumber) {
  final appCtr = ref.watch(applicationControllerProvider);
  return appCtr.getApplicationByStudentNumber(studentNumber: studentNumber);
});

final getApplicationProvider =
    FutureProvider.family((ref, String studentNumber) {
  final appCtr = ref.watch(applicationControllerProvider);
  return appCtr.getApplication(studentNumber: studentNumber);
});

final getLatestApplicationsProvider = StreamProvider((ref) {
  final adminApplicationsApi = ref.watch(adminApplicationsApiProvider);
  return adminApplicationsApi.getLatestApplications();
});

class ApplicationsController extends StateNotifier<bool> {
  ApplicationsController({required AdminApplicationsApi applicationsApi})
      : _applicationsApi = applicationsApi,
        super(false);
  final AdminApplicationsApi _applicationsApi;
  final Logger logger = Logger();

  Future<List<ApplicationModel>> getApplications() =>
      _applicationsApi.getApplications();

  Future<ApplicationModel> getApplicationByStudentNumber(
      {required String studentNumber}) async {
    final applications = await getApplications();
    final application = applications.firstWhere(
      (app) => app.student!.studentNumber == studentNumber,
    );
    return application;
  }

  Future<List<ApplicationModel>> searchApplications(
      {required String query}) async {
    final applications = await getApplications();
    return applications.where((application) {
      bool condition = query.isEmpty
          ? false
          : application.student!.studentNumber.contains(query);
      return condition;
    }).toList();
  }

  Future<ApplicationModel?> getApplication(
      {required String studentNumber}) async {
    final res = await _applicationsApi.getApplication(
      studentNumber: studentNumber,
    );
    return res.fold((l) {
      logger.e(
        'Error on get application $studentNumber',
        error: l.error,
        stackTrace: l.stackTrace,
      );
      return null;
    }, (r) {
      return r;
    });
  }

  void responding(
      {required ApplicationModel application,
      required BuildContext context}) async {
    showLoadingDialog(context: context);
    final res = await _applicationsApi.responding(application: application);
    res.fold((l) {
      showLoadingDialog(context: context, done: true);
      showErrorDialog(
        context: context,
        error: l.message ?? 'UNKOWN ERROR',
      );
    }, (r) {
      showLoadingDialog(context: context, done: true);
      return null;
    });
  }
}
