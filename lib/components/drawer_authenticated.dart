import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/components/copyright_widget.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';

class DrawerAuthenticated extends StatelessWidget {
  final User user;

  const DrawerAuthenticated({
    Key? key,
    required this.user,
  }) : super(key: key);

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
              child: user.picture == null
                  ? Text(
                      user.initials,
                      style: const TextStyle(fontSize: 20),
                    )
                  : null,
              backgroundImage: user.picture != null
                  ? FadeInImage(
                      placeholder: Image.asset(
                        'assets/loading.gif',
                        fit: BoxFit.fill,
                      ).image,
                      imageErrorBuilder: (_, __, ___) {
                        return Image.asset(
                          'assets/placeholder.png',
                          fit: BoxFit.fill,
                        );
                      },
                      image: Image.network(
                        user.picture!,
                        fit: BoxFit.fill,
                        errorBuilder: (ctx, obj, stack) {
                          return Image.asset(
                            'assets/placeholder.png',
                            fit: BoxFit.fill,
                          );
                        },
                      ).image,
                      fit: BoxFit.cover,
                    ).image
                  : null,
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
              Navigator.pushNamed(context, Routes.profile);
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
          const Spacer(),
          TextButton(
            onPressed: () async {
              await AuthService().logout();
              await TokenStorage.removeToken();
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            child: Text(
              'D??connexion',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: size.height / 40),
            child: const Center(
              child: CopyrightWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
