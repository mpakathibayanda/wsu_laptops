import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';

final admniAuthAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return AdmniAuthAPI(db: db);
});

abstract class IAdmniAuthAPI {
  FutureEither<Document> login(
      {required String staffNumber, required String pin});
  Future<String?> currentAdminCred();
  FutureEitherVoid logout();
}

class AdmniAuthAPI implements IAdmniAuthAPI {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Databases _db;
  final Logger _logger = Logger();
  AdmniAuthAPI({required db}) : _db = db;

  @override
  FutureEither<Document> login(
      {required String staffNumber, required String pin}) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.adminCollection,
        documentId: staffNumber,
      );

      Map cred = doc.data;
      if (cred['pin'] == pin) {
        final pref = await _prefs;
        pref.setString('staffNumber', staffNumber);
        pref.setString('pin', pin);
        _logger.i('Logged in succefully');
        return right(doc);
      } else {
        logout();
        _logger.w('Invalid credentials');
        return left(
          const Failure(message: 'Invalid credentials'),
        );
      }
    } on AppwriteException catch (e, stackTrace) {
      logout();
      _logger.e(e.message,
          error: e, stackTrace: stackTrace, time: DateTime.now());
      if (e.message != null) {
        if (e.message!.contains('exceeded')) {
          return left(
            Failure(
              message:
                  'Too many login attempts, you exceeded daily limit, try again later',
              stackTrace: stackTrace,
            ),
          );
        } else if (e.message!
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
              message: 'Anexpected error, check your internet connection',
              stackTrace: stackTrace,
            ),
          );
        }
      } else {
        return left(
          Failure(
            message: 'Unknown error accured',
            stackTrace: stackTrace,
          ),
        );
      }
    } catch (e, stackTrace) {
      _logger.e(e.toString(),
          error: e, stackTrace: stackTrace, time: DateTime.now());
      logout();
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
  Future<String?> currentAdminCred() async {
    try {
      final pref = await _prefs;
      final staffNumber = pref.getString('staffNumber');
      final pin = pref.getString('pin');
      if (staffNumber != null && pin != null) {
        return staffNumber;
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
