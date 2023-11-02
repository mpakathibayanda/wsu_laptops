import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/constants/appwite_consts.dart';
import 'package:wsu_laptops/common/core/failure.dart';
import 'package:wsu_laptops/common/core/providers.dart';
import 'package:wsu_laptops/common/core/type_defs.dart';
import 'package:wsu_laptops/common/models/laptop_model.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/models/admin_model.dart';

final addApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return AddAPI(db: db);
});

abstract class IAddAPI {
  FutureEitherVoid addStudent({required StudentModel student});
  FutureEitherVoid addLaptop({required LaptopModel laptop});
  FutureEitherVoid addAdmin({required AdminModel admin});
}

class AddAPI implements IAddAPI {
  final Databases _db;
  final Logger _logger = Logger();
  AddAPI({required Databases db}) : _db = db;
  @override
  FutureEitherVoid addStudent({required StudentModel student}) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.studentsCollection,
        documentId: student.studentNumber,
        data: student.toMap(),
      );
      _logger.i('Added student: ${res.data}');
      return right(null);
    } on AppwriteException catch (e, s) {
      return left(Failure(message: e.message, stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  FutureEitherVoid addLaptop({required LaptopModel laptop}) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.laptopsCollection,
        documentId: laptop.brandName,
        data: laptop.toAppwrite(),
      );
      _logger.i('Added: ${res.data}');
      return right(null);
    } on AppwriteException catch (e, s) {
      return left(Failure(message: e.message, stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  FutureEitherVoid addAdmin({required AdminModel admin}) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.adminCollection,
        documentId: admin.staffNumber,
        data: admin.toMap(),
      );
      _logger.i('Added admin: ${res.data}');
      return right(null);
    } on AppwriteException catch (e, s) {
      return left(Failure(message: e.message, stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }
}
