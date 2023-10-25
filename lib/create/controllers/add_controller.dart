import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/create/api/add_api.dart';

final addControllerProvider = Provider((ref) {
  final api = ref.watch(addApiProvider);
  return AddController(api: api);
});

class AddController {
  final AddAPI _api;
  final Logger _logger = Logger();
  AddController({required AddAPI api}) : _api = api;

  void addStudent(BuildContext context, {required StudentModel student}) async {
    final res = await _api.addStudent(student: student);
    res.fold(
      (failure) {
        _logger.e(
          failure.message,
          stackTrace: failure.stackTrace,
        );
      },
      (success) {},
    );
  }

  void addStudents(BuildContext context) {
    List<String> campuses = ['Mthatha'];

    for (var c in campuses) {
      int j = 0;
      List<String> stundentNumber = [];
      for (var i = 0; i < 2; i++) {
        String s = j < 10 ? '21712345$j' : '271234$j';
        if (stundentNumber.contains(s)) {
          s = j < 10 ? '21712345$j' : '2171234$j';
        }
        stundentNumber.add(s);
        j++;
        final StudentModel student = StudentModel(
          studentNumber: s,
          name: 'Student${i + 1}',
          surname: 'Surname',
          pin: '12345',
          gender: i == 0 ? 'Male' : 'Female',
          faculty: 'Faculty',
          qualification: 'Qualification',
          level: '3',
          campus: c,
          number: '0731234567',
          isFunded: i == 0 ? 'Yes' : 'No',
        );
        addStudent(context, student: student);
      }
    }
  }
}
