import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/components/profile_circle_avatar.dart';
import 'package:dresscode/components/purchase_history_widget.dart';
import 'package:dresscode/models/user.dart';
import 'package:dresscode/requests/account_update_request.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:dresscode/utils/validator.dart';
import 'package:flutter/material.dart';

import 'package:dresscode/components/profile_screen_entry.dart';

class ProfileInformationWidget extends StatefulWidget {
  const ProfileInformationWidget({Key? key}) : super(key: key);

  @override
  State<ProfileInformationWidget> createState() =>
      _ProfileInformationWidgetState();
}

class _ProfileInformationWidgetState extends State<ProfileInformationWidget> {
  final _authService = AuthService();
  late Future<User> _userFuture;
  late AccountUpdateRequest _accountUpdateRequest;
  bool _wasModified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userFuture = _initUserFuture();
  }

  Future<User> _initUserFuture() async {
    final token = await TokenStorage.getToken();
    final user = (await _authService.getCurrentUser(token))!;
    _accountUpdateRequest = AccountUpdateRequest(
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
    );
    return user;
  }

  Future<void> _updateUser() async {
    final token = await TokenStorage.getToken();
    await _authService.updateUserAccount(_accountUpdateRequest, token);
  }

  Future<void> _cancelUpdate() async {
    final token = await TokenStorage.getToken();
    final user = (await _authService.getCurrentUser(token))!;
    setState(() {
      _accountUpdateRequest = AccountUpdateRequest(
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
      );
      _wasModified = false;
    });
  }

  Future<void> _onProfileImageUpdated(String imagePath) async {
    // TODO
  }

  void _onFirstNameChanged(String? value) {
    setState(() {
      _accountUpdateRequest.firstName =
          value ?? _accountUpdateRequest.firstName;
      _wasModified = true;
    });
  }

  void _onLastNameChanged(String? value) {
    setState(() {
      _accountUpdateRequest.lastName = value ?? _accountUpdateRequest.lastName;
      _wasModified = true;
    });
  }

  void _onPhoneChanged(String? value) {
    setState(() {
      _accountUpdateRequest.phone = value ?? _accountUpdateRequest.phone;
      _wasModified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: ProfileCircleAvatar(
                      user: user!,
                      onPictureChanged: _onProfileImageUpdated,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Text(
                    user.email,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 30, right: 10),
                  child: TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'Mes Informations',
                          style: TextStyle(color: colorScheme.onBackground),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Mes Achats',
                          style: TextStyle(color: colorScheme.onBackground),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          ProfileScreenEntry(
                            icon: Icons.person,
                            label: 'Nom',
                            value: _accountUpdateRequest.lastName,
                            validator: Validator.validateNotEmpty('Nom'),
                            onValueChanged: _onLastNameChanged,
                          ),
                          ProfileScreenEntry(
                            icon: Icons.person,
                            label: 'Prénom(s)',
                            value: _accountUpdateRequest.firstName,
                            validator: Validator.validateNotEmpty('Prénom(s)'),
                            onValueChanged: _onFirstNameChanged,
                          ),
                          ProfileScreenEntry(
                            icon: Icons.phone,
                            label: 'Téléphone',
                            value: _accountUpdateRequest.phone,
                            validator: Validator.validatePhone(),
                            onValueChanged: _onPhoneChanged,
                          ),
                          ProfileScreenEntry(
                            icon: Icons.email,
                            label: 'Adresse mail',
                            value: user.email,
                            editable: false,
                            validator: Validator.validateEmail(),
                          ),
                          if (_wasModified)
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(
                                          40,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          await _updateUser();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Compte mis à jour',
                                              ),
                                            ),
                                          );
                                        } on Exception {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Une erreur s\'est produite',
                                              ),
                                              backgroundColor:
                                                  colorScheme.error,
                                            ),
                                          );
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        child: _isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text('Sauvegarder'),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          await _cancelUpdate();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Modifications annulées',
                                              ),
                                            ),
                                          );
                                        } on Exception {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Une erreur s\'est produite',
                                              ),
                                              backgroundColor:
                                                  colorScheme.error,
                                            ),
                                          );
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        child: _isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text('Annuler'),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(
                                          40,
                                        ),
                                        primary: colorScheme.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                      const PurchaseHistoryWidget(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
