import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wsu_laptops/common/models/student_model.dart';
import 'package:wsu_laptops/common/widgets/laptop_item.dart';
import 'package:wsu_laptops/laptops/controller/laptops_contoller.dart';
import 'package:wsu_laptops/student/applications/views/app_view.dart';

class LaptopsView extends ConsumerStatefulWidget {
  final StudentModel student;
  const LaptopsView({required this.student, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LaptopsViewState();
}

class _LaptopsViewState extends ConsumerState<LaptopsView> {
  void onApplyNow(BuildContext context, List<String> items) {
    Navigator.of(context).canPop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => StudentApplication(widget.student, items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getAllLaptopsProvider(context)).when(
      data: (laptops) {
        if (laptops != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Here are laptops that we offer click for more info',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              ...List.generate(
                laptops.length,
                (index) => LaptopItem(
                  laptop: laptops[index],
                  index: index,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                ),
                onPressed: () {
                  final items = [
                    'SELECT BRAND',
                    ...List.generate(
                      laptops.length,
                      (index) => laptops[index].brandName,
                    ),
                  ];
                  onApplyNow(context, items);
                },
                child: const Text(
                  'Apply Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('No laptops available at the moment'),
          );
        }
      },
      error: (error, stackTrace) {
        final Logger logger = Logger();
        logger.e('Error on loading laptops',
            error: error, stackTrace: stackTrace);
        return const Center(
          child: Text('Error reload this page'),
        );
      },
      loading: () {
        return const Center(
          child: Text('GETTING LAPTOPS...'),
        );
      },
    );
  }
}
