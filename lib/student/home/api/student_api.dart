import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';

final studentApiProvider = Provider((ref) {
  return StudentApi(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IStudentApi {
  Future<Document> getStudentData({required String studentNumber});
  Future<Map<String, dynamic>> getApplication({required String id});
  Stream<RealtimeMessage> getLastestStundentData(
      {required String studentNumber});
  FutureEitherVoid deleteApplication({required String studentNumber});
}

class StudentApi implements IStudentApi {
  final Databases _db;
  final Realtime _realtime;
  final Logger _logger = Logger();

  StudentApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
  @override
  Future<Document> getStudentData({required String studentNumber}) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.studentsCollection,
      documentId: studentNumber,
    );
  }

  @override
  Future<Map<String, dynamic>> getApplication({required String id}) async {
    final appDoc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.applicationsCollection,
      documentId: id,
    );
    Map<String, dynamic> appInfo = appDoc.data;
    _logger.i(
      '[STUDENT API] Got Application',
      time: DateTime.now(),
    );
    return appInfo;
  }

  @override
  Stream<RealtimeMessage> getLastestStundentData({
    required String studentNumber,
  }) {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.applicationsCollection}.documents.$studentNumber'
    ]).stream;
  }

  @override
  FutureEitherVoid deleteApplication({required String studentNumber}) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.applicationsCollection,
        documentId: studentNumber,
      );
      _logger.i(
        '[STUDENT API] Application Deleted',
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
      return left(Failure(stackTrace: s, message: e.message, error: e));
    } catch (e, s) {
      _logger.e(
        'Failed to delete, try agai later',
        error: e,
        stackTrace: s,
        time: DateTime.now(),
      );
      return left(Failure(
        stackTrace: s,
        message: 'Failed to delete, try agai later',
        error: e,
      ));
    }
  }
}
