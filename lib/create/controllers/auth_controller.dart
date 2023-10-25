import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/create/api/auth_api.dart';
import 'package:wsu_laptops/create/views/add_view.dart';

final addAuthProvider = Provider((ref) {
  final api = ref.watch(addAuthApiProvider);
  return AddAuthController(api: api);
});

class AddAuthController {
  final AddAuthApi _api;
  final Logger _logger = Logger();
  AddAuthController({required AddAuthApi api}) : _api = api;

  void login(BuildContext context) async {
    showLoadingDialog(context: context);
    final res = await _api.login();

    res.fold((l) {
      showLoadingDialog(context: context, done: true);
      _logger.e(l.message, stackTrace: l.stackTrace);
      showErrorDialog(
        context: context,
        error: l.message ?? 'Error on login',
      );
    }, (r) {
      showLoadingDialog(context: context, done: true);
      _logger.i('Successful login');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const AddView();
          },
        ),
      );
    });
  }

  Future<bool> isLogin() async {
    final res = await _api.isLogin();
    res.fold(
      (l) {
        _logger.e(l.message, stackTrace: l.stackTrace);
        return false;
      },
      (r) {
        return r;
      },
    );
    return false;
  }
}
