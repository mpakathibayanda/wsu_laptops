import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.black,
            ),
            SizedBox(height: 25),
            Text(
              'LOADING...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            )
          ],
        ),
      )),
    );
  }
}
