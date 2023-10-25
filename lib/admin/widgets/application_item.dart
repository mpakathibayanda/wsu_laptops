import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/views/application_view.dart';
import 'package:wsu_laptops/common/models/application.dart';

class ApplicationItem extends ConsumerWidget {
  final ApplicationModel application;
  const ApplicationItem({super.key, required this.application});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    const style = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    return Tooltip(
      message: 'Click to view more info and respond',
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ApplicationView(
                  studentNumber: application.student!.studentNumber,
                );
              },
            ),
          );
        },
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(vertical: 10).copyWith(left: 10),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(application.student!.name),
                  const SizedBox(width: 10),
                  Text(application.student!.surname),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      application.student!.studentNumber,
                      style: style,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      application.brandName,
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      application.status!,
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Funded: '),
                  Text(
                    application.student!.isFunded,
                    style: style,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
