import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/common/core/utils.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';
import 'package:wsu_laptops/student/auth/controllers/auth_controller.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthView> {
  final studentNumberTxtCtrl = TextEditingController();
  final pinTxtCtrl = TextEditingController();

  void _login() {
    if (studentNumberTxtCtrl.text.length == 9 && pinTxtCtrl.text.length == 5) {
      final authCtrl = ref.read(authControllerProvider);

      authCtrl.login(
        studentNumber: studentNumberTxtCtrl.text,
        pin: pinTxtCtrl.text,
        context: context,
      );
    } else {
      showErrorDialog(
        context: context,
        error: 'Incorrect student number or pin',
      );
    }
  }

  @override
  void initState() {
    // ref.read(authControllerProvider).logout();
    studentNumberTxtCtrl.clear();
    pinTxtCtrl.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    studentNumberTxtCtrl.dispose();
    pinTxtCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppBody(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/wsu.png',
                    height: 60,
                  ),
                  const Text(
                    'LAPTOP APPLICATIONS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    elevation: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.blueAccent,
                          child: const Text(
                            'Prospective Students',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          color: Colors.white,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'In this application WSU students apply for laptops provided that student is funded. If you are not funded please follow this option:',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Go to the finacial office to make down payment of 50%, Scanner receipt to a pdf file, then you can proceed with application here.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    elevation: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.blueAccent,
                          child: const Text(
                            'Registered Students: Login Credentials',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Student Number:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              TextFormField(
                                controller: studentNumberTxtCtrl,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                'Pin:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              TextFormField(
                                controller: pinTxtCtrl,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.black,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _login();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
