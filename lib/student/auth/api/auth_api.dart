import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return AuthAPI(db: db);
});

abstract class IAuthAPI {
  FutureEither<Document> login(
      {required String studentNumber, required String pin});
  Future<String?> currentUserCred();
  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final Databases _db;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Logger _logger = Logger();
  AuthAPI({required db}) : _db = db;

  @override
  FutureEither<Document> login(
      {required String studentNumber, required String pin}) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.studentsCollection,
        documentId: studentNumber,
      );

      Map cred = doc.data;
      if (cred['pin'] == pin) {
        final pref = await _prefs;
        pref.setString('studentNumber', studentNumber);
        pref.setString('pin', pin);
        _logger.i('Logged in succefully');
        return right(doc);
      } else {
        _logger.w('Invalid credentials');
        return left(
          const Failure(message: 'Invalid credentials'),
        );
      }
    } on AppwriteException catch (e, stackTrace) {
      _logger.e(e.message,
          error: e, stackTrace: stackTrace, time: DateTime.now());
      if (e.message != null) {
        if (e.message!
            .contains('Document with the requested ID could not be found')) {
          return left(
            Failure(
              message: 'Invalid credentials',
              stackTrace: stackTrace,
            ),
          );
        } else {
          return left(
            Failure(
              message: 'Unexpected error, check your internet connection',
              stackTrace: stackTrace,
            ),
          );
        }
      } else {
        return left(
          Failure(
            message: 'Unknown error accurred',
            stackTrace: stackTrace,
          ),
        );
      }
    } catch (e, stackTrace) {
      _logger.e(e.toString(),
          error: e, stackTrace: stackTrace, time: DateTime.now());
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      final pref = await _prefs;
      final clr = await pref.clear();
      if (clr) {
        return right(null);
      }
      return left(const Failure(message: 'Cannot logout, try again'));
    } catch (e, stackTrace) {
      _logger.e(e.toString(),
          error: e, stackTrace: stackTrace, time: DateTime.now());
      return left(
        Failure(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<String?> currentUserCred() async {
    try {
      final pref = await _prefs;
      final studNumber = pref.getString('studentNumber');
      final pin = pref.getString('pin');
      if (studNumber != null && pin != null) {
        return studNumber;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      _logger.e(e.toString(),
          error: e, stackTrace: stackTrace, time: DateTime.now());
      return null;
    }
  }
}
