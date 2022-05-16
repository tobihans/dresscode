import 'package:dresscode/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

class ProfileScreenEntry extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool editable;
  final void Function(String?)? onValueChanged;
  final ValidatorFunc? validator;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ProfileScreenEntry({
    Key? key,
    required this.icon,
    required this.label,
    this.value = '',
    this.onValueChanged,
    this.editable = true,
    this.validator,
  }) : super(key: key) {
    _controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Icon(icon),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      showFlexibleBottomSheet(
                        minHeight: 0,
                        initHeight: 0.3,
                        maxHeight: 0.5,
                        anchors: [0, 0.4, 0.5],
                        context: context,
                        builder: (
                          BuildContext context,
                          ScrollController scrollController,
                          double bottomSheetOffset,
                        ) {
                          return SafeArea(
                            child: Material(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 10.0,
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            label: Text(label),
                                          ),
                                          controller: _controller,
                                          validator: validator,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            onValueChanged!(_controller.text);
                                          }
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(editable ? Icons.edit : null),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
