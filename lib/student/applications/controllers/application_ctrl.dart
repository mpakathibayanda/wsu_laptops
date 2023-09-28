import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/student/apis/application_api.dart';
import 'package:wsu_laptops/student/home/views/home_view.dart';

final applicationControllerProvider =
    StateNotifierProvider<ApplicationController, bool>((ref) {
  final appAPI = ref.watch(applicationAPIProvider);
  return ApplicationController(appAPI: appAPI);
});

class ApplicationController extends StateNotifier<bool> {
  final ApplicationAPI _appAPI;
  ApplicationController({required ApplicationAPI appAPI})
      : _appAPI = appAPI,
        super(false);

  void submitApp(
      {required BuildContext context,
      required ApplicationModel application}) async {
    showLoadingDialog(context: context, title: 'Submitting');
    final app = await _appAPI.submitApplitions(application: application);

    app.fold((l) {
      showLoadingDialog(context: context, done: true);
      showErrorDialog(
        context: context,
        error: l.message ??
            'Something went wrong Failed to submit try again later',
      );
    }, (r) {
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
          builder: (context) => HomeView(application.student.studentNumber),
        ),
      );
    });
  }

  Future<ApplicationModel?> getApplicationById({required String id}) async {
    final res = await _appAPI.getApplicationById(id: id);
    return res.fold((l) {
      return null;
    }, (r) {
      return ApplicationModel.fromMap(r.data);
    });
  }
}
