import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/utils/string_extensions.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/utils/string_extensions.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:dresscode/api/services/auth_service.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _initUserFuture();
  }

  Future<User?> _initUserFuture() async {
    final token = await TokenStorage.getToken();
    if (token.isNullOrBlank) {
      return null;
    }
    return await _authService.getCurrentUser(token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: _userFuture,
        builder: (ctx, shapshot) {
          if (shapshot.hasData ||
              shapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: const OwnAppBar(),
              drawer: const AppDrawer(),
              body: Container(),
            );
          }
          return Scaffold();
        });
  }
}
