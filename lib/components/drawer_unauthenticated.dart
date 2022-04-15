import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:flutter/material.dart';

class DrawerUnauthenticated extends StatelessWidget {
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
                  Navigator.pushNamed(context, Routes.login);
                },
                child: const Text('Connexion'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.register);
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
