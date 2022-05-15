import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/components/form_input_borders.dart' as fib;
import 'package:dresscode/requests/login_request.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:dresscode/utils/validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final loginRequest = LoginRequest(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final token = await _authService.login(loginRequest);
    // Trick to load the user in memory
    await _authService.getCurrentUser(token);
    await TokenStorage.saveToken(token);
  }

  @override
  Widget build(BuildContext context) {
    final topMargin = MediaQuery.of(context).size.height / 5;
    final primaryColor = Theme.of(context).colorScheme.primary;
    const allProperties = MaterialStateProperty.all;

    return Scaffold(
      body: Form(
        key: _formKey,
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
                    child: Text(
                      'Connexion',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
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
                          'Email',
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: fib.enabledBorder(),
                          focusedBorder: fib.focusedBorder(primaryColor),
                          errorBorder: fib.errorBorder(),
                          focusedErrorBorder: fib.focusedErrorBorder(),
                          focusColor: Colors.black,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validator.validateEmail(),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          enabledBorder: fib.enabledBorder(),
                          focusedBorder: fib.focusedBorder(primaryColor),
                          errorBorder: fib.errorBorder(),
                          focusedErrorBorder: fib.focusedErrorBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => _isObscure = !_isObscure);
                            },
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
                              _formKey.currentState!.save();
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                await login();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.home,
                                  (r) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Connexion réussie',
                                    ),
                                  ),
                                );
                              } on Exception {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Identifiants invalides'),
                                    backgroundColor: Colors.red,
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
                            'Connexion',
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
                        Navigator.pushNamed(context, Routes.home);
                      },
                      child: const Text('Continuer sans compte'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
