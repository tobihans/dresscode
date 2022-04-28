import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/token_storage.dart';
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
    for (final character in user.name.characters) {
      if (isSpace && character != ' ') {
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
              color: Theme.of(context).colorScheme.primary,
            ),
            currentAccountPicture: CircleAvatar(
              radius: 50.0,
              child: Text(
                _getUserInitials(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            accountEmail: Text(user.email),
            accountName: Text(user.name),
          ),
          ListTile(
            textColor: Theme.of(context).colorScheme.primary,
            title: const Text('Editer le profil'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              _logger.info('Editer le profil');
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height / 200),
            child: ListTile(
              title: const Text('Accueil'),
              leading: const Icon(
                Icons.home,
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.home);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height / 200),
            child: ListTile(
              title: const Text('Voir la boutique'),
              leading: const Icon(
                Icons.shopping_bag,
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.shop);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height / 200),
            child: ListTile(
              title: const Text('Liste de souhaits'),
              leading: const Icon(
                Icons.list,
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.wishlist);
              },
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
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () async {
              await AuthService().logout();
              await TokenStorage.removeToken();
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            child: Text(
              'Déconnexion',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
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
