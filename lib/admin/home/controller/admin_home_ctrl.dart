import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/auth/api/admin_auth_api.dart';
import 'package:wsu_laptops/admin/home/api/admin_api.dart';
import 'package:wsu_laptops/common/models/admin_model.dart';

final adminControllerProvider =
    StateNotifierProvider<AdminController, bool>((ref) {
  return AdminController(
      adminApi: ref.watch(adminApiProvider),
      admniAuthAPI: ref.watch(admniAuthAPIProvider));
});

final getAdminDataProvider = FutureProvider.family((ref, String id) async {
  return ref
      .watch(adminControllerProvider.notifier)
      .getUserData(staffNumber: id);
});

class AdminController extends StateNotifier<bool> {
  AdminController(
      {required AdminApi adminApi, required AdmniAuthAPI admniAuthAPI})
      : _adminApi = adminApi,
        _adminAuthAPI = admniAuthAPI,
        super(false);
  final AdminApi _adminApi;
  final AdmniAuthAPI _adminAuthAPI;

  Future<AdminModel> getUserData({required String staffNumber}) async {
    final document = await _adminApi.getAdminData(staffNumber: staffNumber);
    final updatedUser = AdminModel.fromMap(document.data);
    return updatedUser;
  }

  void logout() => _adminAuthAPI.logout();
}
