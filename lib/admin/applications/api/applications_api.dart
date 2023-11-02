import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';
import 'package:wsu_laptops/common/models/application.dart';

final adminApplicationsApiProvider = Provider((ref) {
  return AdminApplicationsApi(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IAdminApplicationsApi {
  Future<List<ApplicationModel>> getApplications();
  FutureEither<ApplicationModel> getApplication(
      {required String studentNumber});
  Stream<RealtimeMessage> getLatestApplications();
  FutureEitherVoid responding({required ApplicationModel application});
  FutureEitherVoid collecting({required ApplicationModel application});
}

class AdminApplicationsApi extends IAdminApplicationsApi {
  final Databases _db;
  final Realtime _realtime;
  final Logger _logger = Logger();

  AdminApplicationsApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  Future<List<ApplicationModel>> getApplications() async {
    final appsDoc = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.applicationsCollection,
    );
    List<ApplicationModel> apps = [];

    for (var appDoc in appsDoc.documents) {
      ApplicationModel app = ApplicationModel.fromMap(appDoc.data);
      apps.add(app);
    }
    return apps;
  }

  @override
  FutureEitherVoid responding({required ApplicationModel application}) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.applicationsCollection,
        documentId: application.student!.studentNumber,
        data: application.toApp(),
      );
      return right(null);
    } on AppwriteException catch (e, s) {
      return left(
        Failure(message: e.message, stackTrace: s),
      );
    } catch (e, s) {
      return left(
        Failure(message: 'Unkown error accurred', stackTrace: s),
      );
    }
  }

  @override
  Stream<RealtimeMessage> getLatestApplications() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.applicationsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<ApplicationModel> getApplication(
      {required String studentNumber}) async {
    try {
      final appDoc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.applicationsCollection,
        documentId: studentNumber,
      );
      final app = ApplicationModel.fromMap(appDoc.data);
      return right(app);
    } on AppwriteException catch (e, s) {
      _logger.e(
        e.message,
        error: e,
        stackTrace: s,
        time: DateTime.now(),
      );

      return left(Failure(message: e.message, error: e, stackTrace: s));
    } catch (e, s) {
      _logger.e(e.toString(), error: e, stackTrace: s, time: DateTime.now());
      return left(Failure(error: e, stackTrace: s));
    }
  }

  @override
  FutureEitherVoid collecting({required ApplicationModel application}) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.applicationsCollection,
        documentId: application.student!.studentNumber,
        data: application.toApp(),
      );
      return right(null);
    } on AppwriteException catch (e, s) {
      return left(
        Failure(message: e.message, error: e, stackTrace: s),
      );
    } catch (e, s) {
      return left(
        Failure(message: 'Unkown error accurred', error: e, stackTrace: s),
      );
    }
  }
}
