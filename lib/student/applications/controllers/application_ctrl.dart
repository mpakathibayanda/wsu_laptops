import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/student/applications/api/application_api.dart';
import 'package:wsu_laptops/student/home/views/applied_view.dart';

final applicationControllerProvider =
    StateNotifierProvider<ApplicationController, bool>((ref) {
  final appAPI = ref.watch(applicationAPIProvider);
  return ApplicationController(appAPI: appAPI);
});

final getApplicationByIdProvider = FutureProvider.family((ref, String id) {
  final ctrl = ref.watch(applicationControllerProvider.notifier);
  return ctrl.getApplicationById(id: id);
});

class ApplicationController extends StateNotifier<bool> {
  final ApplicationAPI _appAPI;
  final Logger _logger = Logger();
  ApplicationController({required ApplicationAPI appAPI})
      : _appAPI = appAPI,
        super(false);

  void submitApp({
    required BuildContext context,
    required ApplicationModel application,
  }) async {
    showLoadingDialog(context: context, title: 'Submitting');
    final app = await _appAPI.submitApplitions(application: application);
    app.fold(
      (l) {
        showLoadingDialog(context: context, done: true);
        showErrorDialog(
          context: context,
          error: l.message ??
              'Something went wrong Failed to submit try again later',
        );
      },
      (r) {
        showLoadingDialog(context: context, done: true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Align(
              alignment: Alignment.center,
              child: Text(
                'Application Submitted',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppliedPage(
              studentNumber: r['studentNumber'],
            ),
          ),
        );
      },
    );
  }

  Future<ApplicationModel?> getApplicationById({required String id}) async {
    final res = await _appAPI.getApplicationById(id: id);
    return res.fold((l) {
      _logger.e(
        'Error on get applications',
        error: l.error,
        stackTrace: l.stackTrace,
      );
      return null;
    }, (r) {
      if (r.containsKey('not')) {
        return null;
      } else {
        return ApplicationModel.fromMap(r);
      }
    });
  }
}
