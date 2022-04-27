import 'package:dresscode/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeHero extends StatelessWidget {
  final String text;

  const HomeHero({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const url =
        'https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=1';
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.275,
      child: Container(
        child: Stack(children: [
          Container(),
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
                              fontSize: 25.0),
                        )),
                  ),
                  Expanded(child: Container()),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ElevatedButton(
                      onPressed: _heroButtonPressed,
                      child: const Text('Voir'),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 2.5, horizontal: 5.0)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)))),
                    )
                  ]),
                ],
              ))
        ]),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: const DecorationImage(
                image: NetworkImage(url), fit: BoxFit.cover)),
      ),
    );
  }

  void _heroButtonPressed() {}
}
