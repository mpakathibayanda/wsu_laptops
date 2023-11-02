import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/student/auth/api/auth_api.dart';
import 'package:wsu_laptops/student/home/api/student_api.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(
    authAPI: ref.watch(authAPIProvider),
    studentApi: ref.watch(studentApiProvider),
  );
});

final getStudentDataProvider = FutureProvider.family((ref, String id) async {
  return ref
      .watch(homeControllerProvider.notifier)
      .getStudentData(studentNumber: id);
});

final getApplicationProvider = FutureProvider.family((ref, String id) async {
  return ref.watch(homeControllerProvider.notifier).getApplication(id: id);
});

final getLastestStudentDataProvider =
    StreamProvider.family((ref, String studentNumber) {
  final studentApi = ref.watch(studentApiProvider);
  return studentApi.getLastestStundentData(studentNumber: studentNumber);
});

class HomeController extends StateNotifier<bool> {
  HomeController({
    required StudentApi studentApi,
    required AuthAPI authAPI,
  })  : _studentApi = studentApi,
        _authAPI = authAPI,
        super(false);
  final StudentApi _studentApi;
  final AuthAPI _authAPI;

  Future<StudentModel> getStudentData({required String studentNumber}) async {
    final document =
        await _studentApi.getStudentData(studentNumber: studentNumber);
    final updatedUser = StudentModel.fromMap(document.data);
    return updatedUser;
  }

  Future<ApplicationModel> getApplication({required String id}) async {
    final map = await _studentApi.getApplication(id: id);
    return ApplicationModel.fromMap(map);
  }

  void deleteApplication(BuildContext context,
      {required String studentNumber}) async {
    showLoadingDialog(context: context, title: 'Deleting...');
    final res = await _studentApi.deleteApplication(
      studentNumber: studentNumber,
    );

    res.fold((l) {
      showLoadingDialog(context: context, done: true);
      showErrorDialog(
        context: context,
        error: l.message ?? 'Failed, try again later',
      );
    }, (r) {
      showLoadingDialog(context: context, done: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Center(
            child: Text(
              'Application deleted',
            ),
          ),
        ),
      );
    });
  }

  void logout() => _authAPI.logout();
}
