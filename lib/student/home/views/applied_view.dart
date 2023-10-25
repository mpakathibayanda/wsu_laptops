import 'package:flutter/material.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';

class AppliedView extends StatelessWidget {
  final ApplicationModel application;
  final StudentModel student;
  const AppliedView(
      {super.key, required this.application, required this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELCOME ${student.name} ${student.surname}'.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('APPLICATION INFO'),
        Container(
          margin: const EdgeInsets.only(bottom: 8, top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TileTxt(
                txt: 'Brand Name',
                value: application.brandName,
                color: Colors.grey,
              ),
              TileTxt(
                txt: 'Serial Number',
                value: application.serialNumber,
              ),
              TileTxt(
                txt: 'Status',
                value: application.status,
                color: Colors.grey,
              ),
              TileTxt(
                txt: 'Application Date',
                value: dateTime(application.date),
              ),
              TileTxt(
                txt: 'Collecation Date',
                value: dateTime(application.collectionDate ?? 'Pending'),
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
