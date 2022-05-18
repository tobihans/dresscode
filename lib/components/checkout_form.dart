import 'package:dresscode/utils/card_number_formatter.dart';
import 'package:dresscode/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckoutForm extends StatefulWidget {
  final Future<void> Function(String, String, String) onCheckout;

  const CheckoutForm({
    Key? key,
    required this.onCheckout,
  }) : super(key: key);

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _expirationDateController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });
      await widget.onCheckout(
        _cardNumberController.text,
        _expirationDateController.text,
        _postalCodeController.text
      );
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter(),
              ],
              decoration: const InputDecoration(
                hintText: 'Numéro de carte',
                prefixIcon: Icon(Icons.credit_card),
              ),
              validator: Validator.validateNotEmpty('Numéro de carte'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: true,
              controller: _expirationDateController,
              decoration: const InputDecoration(
                hintText: 'Date d\'expiration',
                prefixIcon: Icon(Icons.calendar_month),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2050),
                );
                if (date != null) {
                  _expirationDateController.text =
                      '${date.day}/${date.month}/${date.year}';
                }
              },
              validator: Validator.validateNotEmpty('Date d\'expiration'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _postalCodeController,
              decoration: const InputDecoration(
                hintText: 'Code postal',
                prefixIcon: Icon(Icons.all_inbox),
              ),
              validator: Validator.validateNotEmpty('Code postal'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      )
                    : const Text('Payer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
