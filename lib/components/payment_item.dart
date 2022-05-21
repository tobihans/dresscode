import 'package:dresscode/components/product_tile.dart';
import 'package:dresscode/models/payment.dart';
import 'package:flutter/material.dart';

class PaymentItem extends StatefulWidget {
  final Payment payment;

  const PaymentItem({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  State<PaymentItem> createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            child: Text(
              '${widget.payment.code}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'Effectué le ${widget.payment.createdAt.toString().substring(0, 10)}',
            ),
          ),
          Center(
            child: Text(
              'Montant total : ${widget.payment.price} XOF',
              textAlign: TextAlign.end,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Icon(
              _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
          ),
          if (_expanded)
            Column(
              children: widget.payment.products
                  .map((p) => ProductTile(product: p))
                  .toList(),
            )
        ],
      ),
    );
  }
}
