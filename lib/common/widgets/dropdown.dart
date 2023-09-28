import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';
import 'package:wsu_laptops/student/applications/controllers/application_ctrl.dart';

class AppDropdown extends ConsumerStatefulWidget {
  final String id;
  const AppDropdown(this.id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppDropdownState();
}

class _AppDropdownState extends ConsumerState<AppDropdown> {
  int tabItemIndex = 0;
  Logger logger = Logger();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref
          .watch(applicationControllerProvider.notifier)
          .getApplicationById(id: widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var info = snapshot.data;
          if (info != null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    tabItemIndex = tabItemIndex == 0 ? 1 : 0;
                    setState(() {});
                  },
                  title: const Text('Application Info'),
                  trailing: Icon(
                    tabItemIndex == 0
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                  ),
                ),
                Visibility(
                  visible: tabItemIndex == 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TileTxt(
                          txt: 'Name',
                          value: info.brandName,
                          color: Colors.grey,
                        ),
                        TileTxt(
                          txt: 'Serial Number',
                          value: info.serialNumber,
                        ),
                        TileTxt(
                          txt: 'Status',
                          value: info.status,
                        ),
                        TileTxt(
                          txt: 'Date',
                          value: DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(info.date))
                              .toString(),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text('No Application');
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        if (snapshot.hasError) {
          logger.e(
            'On App info error',
            stackTrace: snapshot.stackTrace,
            error: snapshot.error,
          );
        }
        return Text(snapshot.error.toString());
      },
    );
  }
}
