import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';

final laptopsApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return LaptopsApi(db: db);
});

abstract class ILaptopsApi {
  FutureEither<Document> getLaptopByName({required String name});
  FutureEither<List<Document>> getAllLaptops();
}

class LaptopsApi implements ILaptopsApi {
  final Databases _db;

  LaptopsApi({required Databases db}) : _db = db;

  @override
  FutureEither<List<Document>> getAllLaptops() async {
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.laptopsCollection,
      );
      return right(res.documents);
    } catch (e, s) {
      return left(
        Failure(message: 'Unexpected error occured', stackTrace: s),
      );
    }
  }

  @override
  FutureEither<Document> getLaptopByName({required String name}) async {
    try {
      final res = await _db.getDocument(
        collectionId: AppwriteConstants.laptopsCollection,
        databaseId: AppwriteConstants.databaseId,
        documentId: name,
      );
      return right(res);
    } catch (e, s) {
      return left(
        Failure(message: 'Unexpected error occured', stackTrace: s),
      );
    }
  }
}
