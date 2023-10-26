import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/models/student_model.dart';

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
      databaseId: AppwriteConstants.applicationsDatabaseId,
      collectionId: AppwriteConstants.applicationCollection,
    );
    List<ApplicationModel> apps = [];

    for (var appDoc in appsDoc.documents) {
      ApplicationModel app = ApplicationModel.fromMap(appDoc.data);
      final studDoc = await _db.getDocument(
        databaseId: AppwriteConstants.studentsDatabaseId,
        collectionId: AppwriteConstants.studentsCollection,
        documentId: appDoc.$id,
      );
      final StudentModel student = StudentModel.fromMap(studDoc.data);
      final newApp = app.copyWith(student: student);
      apps.add(newApp);
    }
    return apps;
  }

  @override
  FutureEitherVoid responding({required ApplicationModel application}) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.applicationsDatabaseId,
        collectionId: AppwriteConstants.applicationCollection,
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
      'databases.${AppwriteConstants.applicationsDatabaseId}.collections.${AppwriteConstants.applicationCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<ApplicationModel> getApplication(
      {required String studentNumber}) async {
    try {
      // _logger.f('Requisting Applications info for: $id');
      final appDoc = await _db.getDocument(
        databaseId: AppwriteConstants.applicationsDatabaseId,
        collectionId: AppwriteConstants.applicationCollection,
        documentId: studentNumber,
      );
      final stundentDoc = await _db.getDocument(
        databaseId: AppwriteConstants.studentsDatabaseId,
        collectionId: AppwriteConstants.studentsCollection,
        documentId: studentNumber,
      );

      appDoc.data.addAll(
        {'student': stundentDoc.data},
      );
      final app = ApplicationModel.fromMap(appDoc.data);

      // _logger.i(
      //   'Application info : ${appDoc.data}',
      //   time: DateTime.now(),
      // );
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
}
