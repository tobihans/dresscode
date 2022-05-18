import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/validator.dart';
import 'package:dresscode/components/form_input_borders.dart' as fib;
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> submit() async {
    throw Exception();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topMargin = MediaQuery.of(context).size.height / 5;
    final primaryColor = Theme.of(context).colorScheme.primary;
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
                          'Une fois ce formulaire rempli, votre de récupération vous sera envoyé par mail',
                      child: Text(
                        'Mot de passe oublié',
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
                          'Adresse mail',
                          style: TextStyle(fontSize: 16),
                        ),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                      ),
                      TextFormField(
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
                                await submit();
                              } on Exception {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Une erreur s\'est produite',
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
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
                            'Envoyer le code',
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
                        Navigator.pushNamed(
                          context,
                          Routes.passwordReset,
                        );
                      },
                      child: const Text('Code déjà envoyé ?'),
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
