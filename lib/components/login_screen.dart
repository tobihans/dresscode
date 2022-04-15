import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/requests/login_request.dart';
import 'package:dresscode/utils/colors.dart';
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
    const allProperties = MaterialStateProperty.all;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Container(
            margin: EdgeInsets.only(top: topMargin),
            child: SingleChildScrollView(
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
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(CustomColors.raw['primary']!),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusColor: Colors.black,
                          ),
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
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(CustomColors.raw['primary']!),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
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
                          validator: Validator.validatePassword(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: allProperties(
                          _isLoading
                              ? Colors.grey
                              : Color(CustomColors.raw['primary']!),
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
                                  Navigator.pushNamed(context, Routes.home);
                                } on Exception {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Identifiants invalides'),
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
                    margin: const EdgeInsets.only(top: 20),
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
      ),
    );
  }
}
