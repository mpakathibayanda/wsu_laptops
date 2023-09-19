import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/student/apis/auth_api.dart';
import 'package:wsu_laptops/student/home/views/home_view.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);
  Future<User?> currentUser() => _authAPI.currentUserAccount();
  void login({
    required String studentNumber,
    required String pin,
    required BuildContext context,
  }) async {
    showLoadingDialog(context: context, title: 'Login...');
    final res = await _authAPI.login(studentNumber: studentNumber, pin: pin);

    res.fold(
      (l) {
        showLoadingDialog(context: context, done: true);
        showErrorDialog(context: context, error: l.message ?? 'ERROR');

        // print(l.message);
        // print(l.stackTrace);
      },
      (r) {
        showLoadingDialog(context: context, done: true);
        Navigator.pushReplacement(context, HomeView.route());
      },
    );
  }

  void resetPrefs() async {
    await _authAPI.resetPrefs();
  }

  void logout() async {
    await _authAPI.logout();
  }
}
