import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';
import 'package:wsu_laptops/common/models/application.dart';

final applicationAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return ApplicationAPI(db: db);
});

abstract class IApplicationAPI {
  FutureEither<Map<String, dynamic>> submitApplitions(
      {required ApplicationModel application});
  FutureEither<Map<String, dynamic>> getApplicationById({required String id});
}

class ApplicationAPI implements IApplicationAPI {
  final Databases _db;

  final Logger _logger = Logger();

  ApplicationAPI({required Databases db}) : _db = db;
  @override
  FutureEither<Map<String, dynamic>> submitApplitions(
      {required ApplicationModel application}) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.applicationsCollection,
        documentId: application.student!.studentNumber,
        data: application.toApp(),
      );
      _logger.i(
        'Application submitted',
        time: DateTime.now(),
      );
      return right(res.data);
    } on AppwriteException catch (e, s) {
      _logger.e(e.message, error: e, stackTrace: s, time: DateTime.now());
      return left(Failure(stackTrace: s));
    } catch (e, s) {
      _logger.e(e.toString(), error: e, stackTrace: s, time: DateTime.now());
      return left(Failure(stackTrace: s));
    }
  }

  @override
  FutureEither<Map<String, dynamic>> getApplicationById(
      {required String id}) async {
    try {
      final appDoc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.applicationsCollection,
        documentId: id,
      );
      Map<String, dynamic> appInfo = appDoc.data;
      _logger.i(
        '[APPLICATION API] Got Application',
        time: DateTime.now(),
      );
      return right(appInfo);
    } on AppwriteException catch (e, s) {
      if (e.message != null) {
        if (e.message!
            .contains('Document with the requested ID could not be found')) {
          return right({'not': true});
        }
      }
      _logger.e(
        e.message,
        error: e,
        stackTrace: s,
        time: DateTime.now(),
      );
      return left(Failure(stackTrace: s));
    } catch (e, s) {
      _logger.e(e.toString(), error: e, stackTrace: s, time: DateTime.now());
      return left(Failure(stackTrace: s));
    }
  }
}
