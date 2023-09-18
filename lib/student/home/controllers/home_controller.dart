import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/student/apis/auth_api.dart';
import 'package:wsu_laptops/student/apis/student_api.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(
    authAPI: ref.watch(authAPIProvider),
    studentApi: ref.watch(studentApiProvider),
  );
});

final studentDataProvider = FutureProvider((ref) {
  return ref.watch(homeControllerProvider.notifier).getUserData();
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

  Future<StudentModel> getUserData() async {
    final document = await _studentApi.getStudentData();
    final updatedUser = StudentModel.fromMap(document.data);
    return updatedUser;
  }

  void logout() => _authAPI.logout();
}
