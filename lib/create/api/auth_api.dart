import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';

final addAuthApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AddAuthApi(account: account);
});

class AddAuthApi {
  final Account _account;
  AddAuthApi({required Account account}) : _account = account;

  FutureEitherVoid login() async {
    try {
      await _account.createEmailSession(
        email: 'test@gmail.com',
        password: 'Test1234',
      );
      return right(null);
    } on AppwriteException catch (e, s) {
      if (e.message != null) {
        if (e.message!.contains('guests')) {
          return right(null);
        }
      }
      return left(
        Failure(message: e.message, stackTrace: s),
      );
    } catch (e, s) {
      return left(
        Failure(message: e.toString(), stackTrace: s),
      );
    }
  }

  FutureEither<bool> isLogin() async {
    try {
      User user = await _account.get();
      return right(user.$id.isNotEmpty);
    } on AppwriteException catch (e, s) {
      if (e.message != null) {
        if (e.message!.contains('guests')) {
          return right(false);
        }
      }
      return left(
        Failure(message: e.message, stackTrace: s),
      );
    } catch (e, s) {
      return left(
        Failure(message: e.toString(), stackTrace: s),
      );
    }
  }
}
