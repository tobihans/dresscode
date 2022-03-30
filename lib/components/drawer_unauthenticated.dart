import 'package:dresscode/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// TODO : Get the real User account data
/// TODO : connect the actions
class DrawerUnauthenticated extends StatelessWidget {
  static final logger = Logger('$DrawerUnauthenticated');

  const DrawerUnauthenticated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          const Text('Bienvenue à bord !'),
          Container(
            height: size.height / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  logger.info('Connexion');
                },
                child: const Text('Connexion'),
                style: ElevatedButton.styleFrom(
                  primary: Color(CustomColors.raw['primaryBg']!),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  logger.info('Inscription');
                },
                child:  Text(
                  'Inscription',
                  style: TextStyle(color: Color(CustomColors.raw['primaryBg']!)),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: BorderSide(
                    width: 1.0,
                    color: Color(CustomColors.raw['primaryBg']!),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: size.height / 40),
                child: const Text('Copyright © DressCode 2022'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
