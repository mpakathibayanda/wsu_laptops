import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/laptop_model.dart';
import 'package:wsu_laptops/laptops/api/laptops_api.dart';

final laptopsControlProvider = Provider((ref) {
  final api = ref.watch(laptopsApiProvider);
  return LaptopsController(api: api);
});

final getAllLaptopsProvider =
    FutureProvider.family((ref, BuildContext context) {
  final ctrl = ref.watch(laptopsControlProvider);
  return ctrl.getAllLaptops(context);
});

class LaptopsController extends StateNotifier<bool> {
  final LaptopsApi _api;
  LaptopsController({required LaptopsApi api})
      : _api = api,
        super(false);

  Future<LaptopModel?> getLaptopByName(BuildContext context,
      {required String name}) async {
    state = true;
    final res = await _api.getLaptopByName(name: name);
    state = false;
    return res.fold(
      (l) {
        showErrorDialog(
          context: context,
          error: l.message ?? 'Error on retriving laptop $name',
        );
        return null;
      },
      (r) {
        final laptop = LaptopModel.fromMap(r.data);
        return laptop;
      },
    );
  }

  Future<List<LaptopModel>?> getAllLaptops(BuildContext context) async {
    state = true;
    final res = await _api.getAllLaptops();
    state = false;
    return res.fold(
      (l) {
        showErrorDialog(
          context: context,
          error: l.message ?? 'Error on retriving laptops',
        );
        return null;
      },
      (r) {
        final laptops = r.map((e) => LaptopModel.fromMap(e.data)).toList();
        return laptops;
      },
    );
  }
}
