import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/profile_screen_entry.dart';
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

  String _getUserInitials(String username) {
    final initialsBuilder = StringBuffer();
    var isSpace = true;
    for (final character in username.characters) {
      if (isSpace && character != ' ') {
        initialsBuilder.write(character);
      }
      isSpace = character == ' ';
    }
    return initialsBuilder.toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (ctx, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data;
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Center(
                          child: CircleAvatar(
                              backgroundColor:
                                  const Color(0xFF000000).withOpacity(0.2),
                              radius: 50.0,
                              child: Text(_getUserInitials(user!.name),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: const Color(0xFF111827)
                                          .withOpacity(0.7)))))),
                  ProfileScreenEntry(
                      icon: Icons.person, label: "Nom", value: user.name),
                  ProfileScreenEntry(
                      icon: Icons.person, label: "Prenoms", value: user.name),
                  ProfileScreenEntry(
                      icon: Icons.phone, label: "Telephone", value: user.phone),
                  ProfileScreenEntry(
                      icon: Icons.email,
                      label: "Email",
                      value: user.email,
                      editable: false),
                  const ProfileScreenEntry(
                      icon: Icons.lock,
                      label: "Mot de passe",
                      value: "--------------------------------"),
                ],
              ),
            );
          }
          return const Center(child: Text("Vous devez vous connecter"));
        },
      ),
    );
  }
}
