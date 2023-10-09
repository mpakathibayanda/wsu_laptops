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
  FutureEitherVoid submitApplitions({required ApplicationModel application});
  FutureEither<Map<String, dynamic>> getApplicationById({required String id});
}

class ApplicationAPI implements IApplicationAPI {
  final Databases _db;

  final Logger _logger = Logger();

  ApplicationAPI({required Databases db}) : _db = db;
  @override
  FutureEitherVoid submitApplitions(
      {required ApplicationModel application}) async {
    try {
      _logger.f(application);
      await _db.createDocument(
        databaseId: AppwriteConstants.applicationsDatabaseId,
        collectionId: AppwriteConstants.applicationCollection,
        documentId: application.student!.studentNumber,
        data: application.toApp(),
      );
      await _db.updateDocument(
          databaseId: AppwriteConstants.studentsDatabaseId,
          collectionId: AppwriteConstants.studentsCollection,
          documentId: application.student!.studentNumber,
          data: {
            'status': 'Submitted',
            'laptopName': application.brandName,
            'laptopSerialNumber': 'N/A',
          });
      _logger.i(
        'Application submitted',
        time: DateTime.now(),
      );
      return right(null);
    } on AppwriteException catch (e, s) {
      _logger.e(
        e.message,
        error: e,
        stackTrace: s,
        time: DateTime.now(),
      );
      return left(Failure(stackTrace: s));
    } catch (e, s) {
      _logger.e(
        e.toString(),
        error: e,
        stackTrace: s,
        time: DateTime.now(),
      );
      return left(Failure(stackTrace: s));
    }
  }

  @override
  FutureEither<Map<String, dynamic>> getApplicationById(
      {required String id}) async {
    try {
      _logger.f('Requisting Applications info for: $id');
      final appDoc = await _db.getDocument(
        databaseId: AppwriteConstants.applicationsDatabaseId,
        collectionId: AppwriteConstants.applicationCollection,
        documentId: id,
      );

      final stundentDoc = await _db.getDocument(
        databaseId: AppwriteConstants.studentsDatabaseId,
        collectionId: AppwriteConstants.studentsCollection,
        documentId: id,
      );
      Map<String, dynamic> appInfo = appDoc.data;

      appDoc.data.addAll(
        {'student': stundentDoc.data},
      );

      _logger.i(
        'Application info : ${appDoc.data}',
        time: DateTime.now(),
      );
      return right(appInfo);
    } on AppwriteException catch (e, s) {
      _logger.e(
        e.message,
        error: e,
        stackTrace: s,
        time: DateTime.now(),
      );
      return left(Failure(stackTrace: s));
    } catch (e, s) {
      _logger.e(
        e.toString(),
        error: e,
        stackTrace: s,
        time: DateTime.now(),
      );
      return left(Failure(stackTrace: s));
    }
  }
}
