import 'package:dresscode/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// TODO : connect the actions
class DrawerUnauthenticated extends StatelessWidget {
  static final _logger = Logger('$DrawerUnauthenticated');

  const DrawerUnauthenticated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.info(CustomColors.raw['primaryBg']);
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
                  _logger.info('Connexion');
                },
                child: const Text('Connexion'),
              ),
              ElevatedButton(
                onPressed: () {
                  _logger.info('Inscription');
                },
                child: Text(
                  'Inscription',
                  style: TextStyle(color: Color(CustomColors.raw['primary']!)),
                ),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 1.5,
                    color: Color(CustomColors.raw['primary']!),
                  ),
                  primary: Colors.white,
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
