import 'dart:convert';

import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/serializable.dart';

class Payment extends Serializable {
  final String? code;
  final DateTime createdAt;
  final int price;
  final List<Product> products;

  const Payment({
    this.code,
    required this.createdAt,
    required this.price,
    required this.products,
  });

  @override
  Payment.fromMap(final Map<String, dynamic> map)
      : code = map['code'] as String?,
        createdAt = DateTime.parse(map['createdAt']),
        price = map['price'] as int,
        products = (map['products'] as List)
            .map((e) => Product.fromMap(e as Map<String, dynamic>))
            .toList(growable: false);

  @override
  factory Payment.fromJson(final String json) {
    final Map<String, dynamic> paymentData = jsonDecode(json);
    return Payment.fromMap(paymentData);
  }

  @override
  Map<String, dynamic> toMap() => {
        'code': code,
        'createdAt': createdAt.toString(),
        'price': price,
        'products': products,
      };
}
