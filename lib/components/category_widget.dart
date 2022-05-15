import 'package:dresscode/models/category.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.100,
      width: size.width * 0.375,
      child: SizedBox.expand(
        child: Container(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0XFF000000).withOpacity(0.65),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Center(
                child: Text(category.name),
              ),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                category.url,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
