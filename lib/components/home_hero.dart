import 'package:dresscode/utils/colors.dart';
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
        padding: const EdgeInsets.only(right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: _heroButtonPressed,
                child: Text(
                  'Voir',
                  style: TextStyle(
                    // color: Color(CustomColors.raw['lightGreyBg']!),
                  ),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      vertical: 2.5, horizontal: 5.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              )
            ]),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: const DecorationImage(
                image: NetworkImage(url), fit: BoxFit.cover)),
      ),
    );
  }

  void _heroButtonPressed() {}
}
