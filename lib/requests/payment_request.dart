import 'dart:convert';

class PaymentRequest {
  final String id;
  final String object;
  final String clientIp;
  final int created;
  final bool livemode;
  final String type;
  final bool used;
  final int price;
  final PaymentCard card;
  final List<String> productsCode;

  PaymentRequest({
    required this.id,
    required this.object,
    required this.card,
    required this.clientIp,
    required this.created,
    required this.livemode,
    required this.type,
    required this.used,
    required this.price,
    required this.productsCode,
  });

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['card'] = card.toMap();
    data['client_ip'] = clientIp;
    data['created'] = created;
    data['livemode'] = livemode;
    data['type'] = type;
    data['used'] = used;
    data['price'] = price;
    data['productsCode'] = productsCode;
    return jsonEncode(data);
  }
}

class PaymentCard {
  String id;
  String object;
  String addressZip;
  String brand;
  String country;
  String cvcCheck;
  String dynamicLast4;
  int expMonth;
  int expYear;
  String funding;
  String last4;

  PaymentCard({
    required this.id,
    required this.object,
    required this.addressZip,
    required this.brand,
    required this.country,
    required this.cvcCheck,
    required this.dynamicLast4,
    required this.expMonth,
    required this.expYear,
    required this.funding,
    required this.last4,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['address_zip'] = addressZip;
    data['brand'] = brand;
    data['country'] = country;
    data['cvc_check'] = cvcCheck;
    data['dynamic_last4'] = dynamicLast4;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['funding'] = funding;
    data['last4'] = last4;
    return data;
  }
}
