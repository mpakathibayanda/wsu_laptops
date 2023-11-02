import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wsu_laptops/admin/applications/controller/admin_applications_controller.dart';
import 'package:wsu_laptops/admin/widgets/item.dart';
import 'package:wsu_laptops/common/models/application.dart';
import 'package:wsu_laptops/common/widgets/app_body.dart';

class CollectingView extends ConsumerStatefulWidget {
  final ApplicationModel applicationModel;
  const CollectingView(this.applicationModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CollectingViewState();
}

class _CollectingViewState extends ConsumerState<CollectingView> {
  final serialNumberTxtCtrl = TextEditingController();
  final dateTxtCtrl = TextEditingController();

  void onScan() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AiBarcodeScanner(
          validator: (value) {
            return true;
          },
          onScan: (String value) {
            debugPrint(value);
            setState(() {
              serialNumberTxtCtrl.text = value.trim();
            });
          },
          onDetect: (p0) {
            debugPrint(p0.barcodes.first.displayValue.toString());
          },
          onDispose: () {
            debugPrint("Barcode scanner disposed!");
          },
        ),
      ),
    );
  }

  void onSave() {
    if (serialNumberTxtCtrl.text.isNotEmpty) {
      ApplicationModel newApp = widget.applicationModel.copyWith(
        status: 'Collected',
        serialNumber: serialNumberTxtCtrl.text.trim(),
        collectionDate: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      ref.read(applicationControllerProvider).collecting(
            application: newApp,
            context: context,
          );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter the valid serial number'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    serialNumberTxtCtrl.dispose();
    dateTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final application = widget.applicationModel;
    final student = application.student!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${student.studentNumber}\'s Collection',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AppBody(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.blueGrey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ItemView(
                  label: 'Name',
                  data: student.name,
                ),
                ItemView(
                  label: 'Surname',
                  data: student.surname,
                ),
                ItemView(
                  label: 'Status',
                  data: application.status!,
                ),
                ItemView(
                  label: 'Brand',
                  data: application.brandName,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: serialNumberTxtCtrl,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Click the camera to scan bar',
                      labelText: 'Serial number',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: onScan,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: onSave,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
