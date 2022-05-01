import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/components/form_input_borders.dart' as fib;
import 'package:dresscode/requests/login_request.dart';
import 'package:dresscode/requests/register_request.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:dresscode/utils/validator.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final registerRequest = RegisterRequest(
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );
    final loginSuccessful = await _authService.register(registerRequest);
    if (!loginSuccessful) {
      throw Exception();
    }
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
    final topMargin = MediaQuery.of(context).size.height / 7;
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
                      'Inscription',
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
                          'Nom',
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          enabledBorder: fib.enabledBorder(),
                          focusedBorder: fib.focusedBorder(primaryColor),
                          errorBorder: fib.errorBorder(),
                          focusedErrorBorder: fib.focusedErrorBorder(),
                          focusColor: Colors.black,
                        ),
                        keyboardType: TextInputType.name,
                        validator: Validator.validateNotEmpty('Nom'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: const Text(
                          'Prénom(s)',
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          enabledBorder: fib.enabledBorder(),
                          focusedBorder: fib.focusedBorder(primaryColor),
                          errorBorder: fib.errorBorder(),
                          focusedErrorBorder: fib.focusedErrorBorder(),
                          focusColor: Colors.black,
                        ),
                        keyboardType: TextInputType.name,
                        validator: Validator.validateNotEmpty('Prénoms'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: const Text(
                          'Téléphone',
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          enabledBorder: fib.enabledBorder(),
                          focusedBorder: fib.focusedBorder(primaryColor),
                          errorBorder: fib.errorBorder(),
                          focusedErrorBorder: fib.focusedErrorBorder(),
                          focusColor: Colors.black,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: Validator.validatePhone(),
                      )
                    ],
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
                                await register();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.home,
                                  (r) => false,
                                );
                              } on Exception {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Une erreur s\'est produite'),
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
                            'Inscription',
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
                        Navigator.pushNamed(context, Routes.login);
                      },
                      child: const Text('Déjà inscrit ? Connectez vous'),
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
