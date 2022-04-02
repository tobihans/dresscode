import 'package:flutter/material.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.25,
      widthFactor: 1,
      child: Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
              onPressed: _heroButtonPressed, child: const Text('Voir')),
        ),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=1'))),
      ),
    );
  }

  void _heroButtonPressed() {}
}
