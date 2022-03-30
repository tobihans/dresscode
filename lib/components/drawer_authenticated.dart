import 'dart:math';

import 'package:dresscode/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// TODO : Change the colors to match the app colors
/// TODO : Get the real User account data
/// TODO : connect the actions
class DrawerAuthenticated extends StatelessWidget {
  const DrawerAuthenticated({Key? key}) : super(key: key);
  static final logger = Logger('$DrawerAuthenticated');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(CustomColors.raw['primaryBg']!),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 50.0,
              backgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: const Text(
                'J',
                style: TextStyle(fontSize: 20),
              ),
            ),
            accountEmail: const Text('jess@coco.om'),
            accountName: const Text('Jess Coco'),
          ),
          ListTile(
            textColor: Color(CustomColors.raw['primaryBg']!),
            title: const Text('Editer le profil'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color(CustomColors.raw['primaryBg']!),
            ),
            onTap: () {
              logger.info('Editer le profil');
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height / 200),
            child: ListTile(
              title: const Text('Liste de souhaits'),
              leading: const Icon(
                Icons.list,
              ),
              onTap: () {
                logger.info('liste de souhaits');
              },
              tileColor: const Color(0x22222200),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height / 200),
            child: ListTile(
              title: const Text('Historique'),
              leading: const Icon(
                Icons.history,
              ),
              onTap: () {
                logger.info('Historique');
              },
              tileColor: const Color(0x22222200),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height / 200),
            child: ListTile(
              title: const Text('Méthodes de paiement'),
              leading: const Icon(
                Icons.payment,
              ),
              onTap: () {
                logger.info('Méthodes de paiement');
              },
              tileColor: const Color(0x22222200),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              logger.info('Déconnexion');
            },
            child: Text(
              'Déconnexion',
              style: TextStyle(color: Color(CustomColors.raw['primaryBg']!)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: size.height / 40),
            child: const Center(
              child: Text('Copyright © DressCode 2022'),
            ),
          ),
        ],
      ),
    );
  }
}
