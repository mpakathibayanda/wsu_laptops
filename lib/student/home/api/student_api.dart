import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/providers.dart';

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
}

class StudentApi implements IStudentApi {
  final Databases _db;
  final Realtime _realtime;

  StudentApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
  @override
  Future<Document> getStudentData({required String studentNumber}) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.studentsDatabaseId,
      collectionId: AppwriteConstants.studentsCollection,
      documentId: studentNumber,
    );
  }

  @override
  Future<Map<String, dynamic>> getApplication({required String id}) async {
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
    return appInfo;
  }

  @override
  Stream<RealtimeMessage> getLastestStundentData({
    required String studentNumber,
  }) {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.applicationsDatabaseId}.collections.${AppwriteConstants.applicationCollection}.documents.$studentNumber'
    ]).stream;
  }
}
