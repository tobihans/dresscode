import 'package:flutter/material.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const url =
        'https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=1';
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.275,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: const DecorationImage(
                image: NetworkImage(url), fit: BoxFit.cover)),
      ),
    );
  }

  // void _heroButtonPressed() {}
}
