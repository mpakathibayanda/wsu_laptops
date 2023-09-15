import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  const AppBody({
    super.key,
    required this.child,
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
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
