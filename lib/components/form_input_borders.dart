import 'package:flutter/material.dart';

/// Some util functions for form input borders building cause they're so similar
/// and I don't want to write the same code over and over again.

OutlineInputBorder enabledBorder() {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      width: 3,
      color: Colors.black,
    ),
    borderRadius: BorderRadius.circular(15),
  );
}

OutlineInputBorder focusedBorder(Color primaryColor) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      width: 3,
      color: primaryColor,
    ),
    borderRadius: BorderRadius.circular(15),
  );
}

OutlineInputBorder errorBorder() {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      width: 3,
      color: Colors.red,
    ),
    borderRadius: BorderRadius.circular(15),
  );
}

OutlineInputBorder focusedErrorBorder() {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      width: 3,
      color: Colors.red,
    ),
    borderRadius: BorderRadius.circular(15),
  );
}
