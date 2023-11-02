import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/admin_model.dart';
import 'package:wsu_laptops/common/models/laptop_model.dart';
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

  void addLaptop(BuildContext context, {required LaptopModel laptop}) async {
    final res = await _api.addLaptop(laptop: laptop);
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

  void addAdmin(BuildContext context, {required AdminModel admin}) async {
    final res = await _api.addAdmin(admin: admin);
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
    List<String> campuses = ['NMD', 'ZMK', 'BIKA', 'BCC'];
    List<String> stn = ['16', '21', '22', '23'];
    showLoadingDialog(context: context, title: 'Adding...');
    for (int i = 0; i < campuses.length; i++) {
      int j = 0;
      for (var k = 0; k < 2; k++) {
        String s = j < 10 ? '2${stn[i]}12345$j' : '271234$j';
        j++;
        final StudentModel student = StudentModel(
          studentNumber: s,
          name: k == 0 ? 'Lutho' : 'Sinovuyo',
          surname: k == 0 ? 'Lulwandle' : 'Gorgeous',
          pin: '12345',
          gender: k == 0 ? 'Male' : 'Female',
          faculty: 'Faculty',
          qualification: 'Qualification',
          level: '3',
          campus: campuses[i],
          number: '0731234567',
          isFunded: k == 0 ? 'No' : 'Yes',
        );
        addStudent(context, student: student);
      }
    }
    showLoadingDialog(context: context, done: true);
  }

  void addLaptops(BuildContext context) {
    List<LaptopModel> laptops = [
      LaptopModel(
        brandName: 'Lenovo',
        price: 'R4599.99',
        warrant: '3 years',
        ramSize: '4GB',
        storage: '500GB',
      ),
      LaptopModel(
        brandName: 'HP',
        price: 'R4599.99',
        warrant: '3 years',
        ramSize: '4GB',
        storage: '500GB',
      ),
      LaptopModel(
        brandName: 'ACER',
        price: 'R4599.99',
        warrant: '3 years',
        ramSize: '4GB',
        storage: '500GB',
      ),
      LaptopModel(
        brandName: 'ASUS',
        price: 'R4599.99',
        warrant: '3 years',
        ramSize: '4GB',
        storage: '500GB',
      ),
    ];

    for (LaptopModel laptop in laptops) {
      addLaptop(context, laptop: laptop);
    }
  }

  void addAdmins(BuildContext context) {
    List<AdminModel> admins = [
      AdminModel(
        staffNumber: '400123',
        pin: '12345',
        name: 'Sanele',
        surname: 'Mpisi',
        gender: 'Male',
        role: 'Educational Technologist',
        site: 'NMD',
      ),
    ];

    for (AdminModel admin in admins) {
      addAdmin(context, admin: admin);
    }
  }
}
