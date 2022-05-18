import 'package:flutter/material.dart';

import 'package:dresscode/utils/routes.dart';

class HomeHero extends StatelessWidget {
  final String text;

  const HomeHero({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const url =
        'https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=1';
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.275,
      child: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0XFF000000).withOpacity(0.55),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.shop);
                      },
                      icon: const Icon(Icons.arrow_circle_right_outlined),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: const DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
