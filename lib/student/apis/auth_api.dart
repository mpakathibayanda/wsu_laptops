import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final db = ref.watch(appwriteDatabaseProvider);
  return AuthAPI(account: account, db: db);
});

abstract class IAuthAPI {
  FutureEitherVoid login({required String studentNumber, required String pin});
  Future<User?> currentUserAccount();
  FutureEitherVoid resetPrefs();
  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  final Databases _db;
  AuthAPI({required Account account, required db})
      : _account = account,
        _db = db;

  @override
  FutureEitherVoid login(
      {required String studentNumber, required String pin}) async {
    try {
      await _account.createEmailSession(
        email: 'test@gmail.com',
        password: 'Test1234',
      );
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.credentialCollection,
        documentId: studentNumber,
      );
      Map cred = doc.data;
      if (cred['pin'] == pin) {
        await _account.updatePrefs(
          prefs: <String, String>{'studentNumber': studentNumber},
        );
        return right(null);
      } else {
        logout();
        return left(
          const Failure(message: 'Invalid credentials'),
        );
      }
    } on AppwriteException catch (e, stackTrace) {
      logout();
      if (e.code == 404) {
        return left(
          const Failure(message: 'Invalid credentials'),
        );
      }

      return left(
        Failure(
          message: e.message ?? 'Something went wrong?',
          stackTrace: stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      logout();
      return left(
        Failure(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.updatePrefs(prefs: {'studentNumber': ''});
      await _account.deleteSession(sessionId: 'current');

      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          message: e.message ?? 'Some unexpected error occurred',
          stackTrace: stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEitherVoid resetPrefs() async {
    try {
      await _account.updatePrefs(prefs: {'studentNumber': ''});
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          message: e.message ?? 'Some unexpected error occurred',
          stackTrace: stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }
}
