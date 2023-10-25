import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/models/student_model.dart';

final applicationControllerProvider = StateProvider((ref) {
  return ApplicationsController();
});

final getAllApplicationsProvider = Provider((ref) {
  final appCtr = ref.watch(applicationControllerProvider);
  return appCtr.applications();
});

final searchApplicationsProvider = StateProvider.family((ref, String query) {
  final appCtr = ref.watch(applicationControllerProvider);
  return appCtr.searchApplications(query: query);
});

final getApplicationByStudentNumberProvider =
    Provider.family((ref, String studentNumber) {
  final appCtr = ref.watch(applicationControllerProvider);

  return appCtr.getApplicationByStudentNumber(studentNumber: studentNumber);
});

class ApplicationsController extends StateNotifier<bool> {
  ApplicationsController() : super(false);

  List<ApplicationModel> applications() => List.generate(
        5,
        (index) => ApplicationModel(
          student: StudentModel(
            studentNumber: '22012345${index + 1}',
            name: 'Name ${index + 1}',
            surname: 'Surname ${index + 1}',
            gender: 'Female',
            faculty: 'Natural Sciences',
            qualification: 'Bsc in Mathematics',
            level: '3',
            number: '0731234567',
            isFunded: 'Yes',
            campus: 'NMD',
          ),
          brandName: 'Lenova',
          date: '2023-09-10',
          status: 'Submitted',
          isFunded: 'Yes',
        ),
      );

  ApplicationModel getApplicationByStudentNumber(
      {required String studentNumber}) {
    ApplicationModel application = applications().firstWhere(
      (app) => app.student!.studentNumber == studentNumber,
    );
    return application;
  }

  List<ApplicationModel> searchApplications({required String query}) {
    return applications().where((application) {
      bool condition = query.isEmpty
          ? false
          : application.student!.studentNumber.contains(query);
      return condition;
    }).toList();
  }
}
