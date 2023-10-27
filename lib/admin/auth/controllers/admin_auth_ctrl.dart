import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/auth/api/admin_auth_api.dart';
import 'package:wsu_laptops/admin/home/views/admin_home_view.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/admin_model.dart';

final adminAuthControllerProvider = Provider<AdminAuthController>((ref) {
  return AdminAuthController(
    authAPI: ref.watch(admniAuthAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final adminAuthController = ref.watch(adminAuthControllerProvider);
  return adminAuthController.currentUser();
});

class AdminAuthController extends StateNotifier<bool> {
  final AdmniAuthAPI _authAPI;
  AdminAuthController({required AdmniAuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);
  Future<User?> currentUser() => _authAPI.currentUserAccount();
  void login({
    required String staffNumber,
    required String pin,
    required BuildContext context,
  }) async {
    showLoadingDialog(context: context, title: 'Login...');
    final res = await _authAPI.login(staffNumber: staffNumber, pin: pin);

    res.fold(
      (l) {
        showLoadingDialog(context: context, done: true);
        showErrorDialog(context: context, error: l.message ?? 'ERROR');
      },
      (r) {
        AdminModel admin = AdminModel.fromMap(r.data);
        showLoadingDialog(context: context, done: true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomeView(admin.staffNumber),
          ),
        );
      },
    );
  }

  void logout() async {
    await _authAPI.logout();
  }
}
