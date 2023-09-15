import 'package:flutter/material.dart';

class TileTxt extends StatelessWidget {
  final Color? color;
  final String? txt;
  final String? value;
  const TileTxt({
    super.key,
    this.color,
    this.txt,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              txt ?? 'TEXT HERE',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Value here',
            ),
          ),
        ],
      ),
    );
  }
}
