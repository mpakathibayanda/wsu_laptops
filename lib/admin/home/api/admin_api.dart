import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/providers.dart';

final adminApiProvider = Provider((ref) {
  return AdminApi(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IAdminApi {
  Future<Document> getAdminData({required String staffNumber});
}

class AdminApi implements IAdminApi {
  final Databases _db;

  AdminApi({required Databases db}) : _db = db;
  @override
  Future<Document> getAdminData({required String staffNumber}) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.adminDatabaseId,
      collectionId: AppwriteConstants.adminCollection,
      documentId: staffNumber,
    );
  }
}
