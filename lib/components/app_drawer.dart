import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/components/drawer_authenticated.dart';
import 'package:dresscode/components/drawer_unauthenticated.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/utils/string_extensions.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';

/// Drawer for the app
/// Returns the well suited drawer depending on if the user is authenticated or not
class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _authService = AuthService();
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _initUserFuture();
  }

  Future<User?> _initUserFuture() async {
    final token = await TokenStorage.getToken();
    if(token.isNullOrBlank) {
      return null;
    }
    return await _authService.getCurrentUser(token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (ctx, snapshot) {
        if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data;
          return user == null
              ? const DrawerUnauthenticated()
              : DrawerAuthenticated(user: user);
        } else if (snapshot.hasError) {
          return const Drawer(
            child: Center(
              child: Text(
                'Une erreur s\'est produite 🥲',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else {
          return Drawer(
            child: Center(
              child: CircularProgressIndicator(
                color: Color(CustomColors.raw['primary']!),
              ),
            ),
          );
        }
      },
    );
  }
}
