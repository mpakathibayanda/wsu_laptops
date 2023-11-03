// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/auth/views/admin_auth_view.dart';
import 'package:wsu_laptops/admin/auth/views/admin_redirect.dart';
import 'package:wsu_laptops/create/views/add_redirect_view.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/auth/view/redirect.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WSU Laptops Application Portal',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              textStyle: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        home: const AdminRedirectView() //FOR ADMIN APP
        // home: const StudentRedirectView(), // FOR STUDENT APP
        // home: const AddRedictPage(), // FOR CREATE APP
        );
  }
}
