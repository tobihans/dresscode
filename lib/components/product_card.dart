import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String url;
  final String name;
  final double price;

  const ProductCard(
      {Key? key, required this.name, required this.url, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(child: Scaffold());
  }
}
