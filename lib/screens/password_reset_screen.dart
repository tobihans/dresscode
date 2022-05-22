import 'package:dresscode/api/services/password_recuperation_service.dart';
import 'package:dresscode/requests/password_reset_request.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/validator.dart';
import 'package:dresscode/components/form_input_borders.dart' as fib;

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRecuperationService = PasswordRecuperationService();
  bool _isLoading = false;
  bool _isObscure = true;

  void togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<bool> submit() async {
    return await _passwordRecuperationService
        .resetUserPassword(PasswordResetRequest(
      token: _codeController.text,
      password: _passwordController.text,
    ));
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topMargin = MediaQuery.of(context).size.height / 5;
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final errorColor = colorScheme.error;
    const allProperties = MaterialStateProperty.all;
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: topMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: const Center(
                    child: Tooltip(
                      message:
                          'Rentrez le code qui vous a été envoyé par mail et entre votre nouveau mot de passe',
                      child: Text(
                        'Réinitialisation de votre mot de passe',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: const Text(
                          'Code',
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                      ),
                      TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          enabledBorder: fib.enabledBorder(),
                          focusedBorder: fib.focusedBorder(primaryColor),
                          errorBorder: fib.errorBorder(),
                          focusedErrorBorder: fib.focusedErrorBorder(),
                          focusColor: Colors.black,
                        ),
                        keyboardType: TextInputType.text,
                        validator: Validator.validateNotEmpty('Code'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: const Text(
                          'Mot de passe',
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                      ),
                      TextFormField(
                        obscureText: _isObscure,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          enabledBorder: fib.enabledBorder(),
                          focusedBorder: fib.focusedBorder(primaryColor),
                          errorBorder: fib.errorBorder(),
                          focusedErrorBorder: fib.focusedErrorBorder(),
                          suffixIcon: IconButton(
                            onPressed: togglePasswordVisibility,
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: Validator.validateNotEmpty('Mot de passe'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: allProperties(
                        _isLoading ? Colors.grey : primaryColor,
                      ),
                      shape: allProperties(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      padding: allProperties(
                        const EdgeInsets.symmetric(vertical: 17),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                final wasSuccessfull = await submit();
                                if (wasSuccessfull) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Code vérifié. Veuillez vous connecter',
                                      ),
                                    ),
                                  );
                                  Navigator.pushNamed(context, Routes.login);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Code invalide ou expiré',
                                      ),
                                      backgroundColor: errorColor,
                                    ),
                                  );
                                }
                              } on Exception {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Une erreur s\'est produite',
                                    ),
                                    backgroundColor: errorColor,
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Réinitialiser mon mot de passe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.register);
                      },
                      child: const Text('Pas de compte ? Inscrivez vous'),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.forgotPassword);
                      },
                      child: const Text('Vous n\'avez pas de code ?'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
