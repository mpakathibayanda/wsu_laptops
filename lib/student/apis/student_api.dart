import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/providers.dart';

final studentApiProvider = Provider((ref) {
  return StudentApi(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IStudentApi {
  Future<Document> getStudentData({required String studentNumber});
}

class StudentApi implements IStudentApi {
  final Databases _db;

  StudentApi({required Databases db}) : _db = db;
  @override
  Future<Document> getStudentData({required String studentNumber}) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.studentsDatabaseId,
      collectionId: AppwriteConstants.studentsCollection,
      documentId: studentNumber,
    );
  }
}
