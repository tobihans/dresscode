import 'package:dresscode/utils/colors.dart';
import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String name;
  final String url;

  const Category({Key? key, required this.name, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
        height: size.height * 0.137,
        width: size.width * 0.375,
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero),
              child: SizedBox.expand(
                child: Container(
                  child: Stack(children: [
                    Container(
                      child: Center(
                        widthFactor: 0.25,
                        child: Text(name),
                      ),
                    ),
                  ]),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      image: DecorationImage(
                          image: NetworkImage(url), fit: BoxFit.cover)),
                ),
              ),
            )));
  }
}
