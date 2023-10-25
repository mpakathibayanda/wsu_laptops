import 'package:flutter/material.dart';
import 'package:wsu_laptops/common/models/laptop_model.dart';

class LaptopItem extends StatefulWidget {
  final LaptopModel laptop;
  final int index;

  const LaptopItem({required this.laptop, super.key, required this.index});

  @override
  State<LaptopItem> createState() => _LaptopItemState();
}

class _LaptopItemState extends State<LaptopItem> {
  int currentIndex = -1;
  void onTap(int index) {
    setState(() {
      currentIndex = currentIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => onTap(widget.index),
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.laptop.brandName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        Visibility(
          visible: currentIndex == widget.index,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              color: Colors.grey,
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Price: R${widget.laptop.price}'),
                  Text('Warrant: ${widget.laptop.warrant} year'),
                  Text('Ram: ${widget.laptop.ramSize} GB'),
                  Text('Storage: ${widget.laptop.storage} GB'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
