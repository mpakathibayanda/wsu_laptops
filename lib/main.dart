import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/widgets/error_page.dart';
import 'package:wsu_laptops/common/widgets/loading_page.dart';
import 'package:wsu_laptops/student/auth/controllers/auth_controller.dart';
import 'package:wsu_laptops/student/auth/view/auth_view.dart';
import 'package:wsu_laptops/student/home/views/home_view.dart';

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
      title: 'WSU Laptops',
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color.fromARGB(255, 157, 199, 233),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              textStyle: const TextStyle(color: Colors.black),
            ),
          )),
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const AuthView();
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
