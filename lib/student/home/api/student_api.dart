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
  Stream<RealtimeMessage> getLastestStundentData();
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
  Stream<RealtimeMessage> getLastestStundentData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.studentsDatabaseId}.collections.${AppwriteConstants.studentsCollection}.documents'
    ]).stream;
  }
}
