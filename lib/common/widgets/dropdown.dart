import 'package:flutter/material.dart';
import 'package:wsu_laptops/common/models/laptop_model.dart';
import 'package:wsu_laptops/common/widgets/tile_text.dart';

class AppDropdown extends StatefulWidget {
  final String title;
  final LaptopModel? laptopInfo;
  const AppDropdown({super.key, required this.title, this.laptopInfo});

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  int tabItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            tabItemIndex = tabItemIndex == 0 ? 1 : 0;
            setState(() {});
          },
          title: Text(widget.title),
          trailing: Icon(
            tabItemIndex == 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up,
          ),
        ),
        Visibility(
          visible: tabItemIndex == 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 8),
            child: widget.laptopInfo != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TileTxt(
                        txt: 'Name',
                        value: widget.laptopInfo?.laptopName,
                        color: Colors.grey,
                      ),
                      TileTxt(
                        txt: 'Serial Number',
                        value: widget.laptopInfo?.laptopSerialNumber,
                      ),
                    ],
                  )
                : const Text('No info'),
          ),
        ),
      ],
    );
  }
}
