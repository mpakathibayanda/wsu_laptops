import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/providers.dart';

final studentApiProvider = Provider((ref) {
  return StudentApi(
    db: ref.watch(appwriteDatabaseProvider),
    account: ref.watch(appwriteAccountProvider),
  );
});

abstract class IStudentApi {
  Future<Document> getStudentData();
}

class StudentApi implements IStudentApi {
  final Databases _db;
  final Account _account;

  StudentApi({required Databases db, required Account account})
      : _db = db,
        _account = account;
  @override
  Future<Document> getStudentData() async {
    final prefs = await _account.getPrefs().then((value) => value.data);
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.studentsCollection,
      documentId: prefs['studentNumber'],
    );
  }
}
