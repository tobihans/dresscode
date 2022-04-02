import 'dart:math';

import 'package:dresscode/models/user.dart';
import 'package:dresscode/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// TODO : connect the actions
class DrawerAuthenticated extends StatelessWidget {
  const DrawerAuthenticated({Key? key, required this.user}) : super(key: key);
  final User user;

  static final _logger = Logger('$DrawerAuthenticated');

  String _getUserInitials() {
    final initialsBuilder = StringBuffer();
    var isSpace = true;
    for(final character in user.name.characters) {
      if(isSpace && character != ' ') {
        initialsBuilder.write(character);
      }
      isSpace = character == ' ';
    }
    return initialsBuilder.toString();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(CustomColors.raw['primary']!),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 50.0,
              backgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Text(
                _getUserInitials(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            accountEmail: Text(user.email),
            accountName: Text(user.name),
          ),
          ListTile(
            textColor: Color(CustomColors.raw['primary']!),
            title: const Text('Editer le profil'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color(CustomColors.raw['primary']!),
            ),
            onTap: () {
              _logger.info('Editer le profil');
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
                _logger.info('liste de souhaits');
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
                _logger.info('Historique');
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
                _logger.info('Méthodes de paiement');
              },
              tileColor: const Color(0x22222200),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              _logger.info('Déconnexion');
            },
            child: Text(
              'Déconnexion',
              style: TextStyle(color: Color(CustomColors.raw['primary']!)),
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
