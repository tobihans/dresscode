import 'package:dresscode/models/payment.dart';
import 'package:flutter/material.dart';

class PaymentItem extends StatelessWidget {
  final Payment payment;

  const PaymentItem({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO
    return Text(payment.toJson());
  }
}
