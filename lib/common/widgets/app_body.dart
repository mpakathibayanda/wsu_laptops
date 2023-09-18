import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  final Color? color;
  const AppBody({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 240,
          maxWidth: 600,
        ),
        height: MediaQuery.of(context).size.height - 25,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
        ),
        child: child,
      ),
    );
  }
}
