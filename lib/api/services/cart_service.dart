import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/notification.dart';

import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/notification_service.dart';

class CartService extends ApiBase {
  final String _token;

  CartService(this._token);

  Future<List<Product>> getCart() async {
    final apiResponse = await get(
      Uri.parse(Constants.cartUrl),
      Constants.emptyMap,
      '',
      _token,
    );
    final content = jsonDecode(apiResponse)['content'] as Map<String, dynamic>;
    return (content['products'] as List)
        .map((e) => Product.fromMap(e))
        .toList(growable: false);
  }

  Future<void> addProductToCart(Product product) async {
    NotificationService.insert(Notification(
      title: 'Panier',
      content: 'Produit ${product.name} ajouté au panier',
    ));
    await post(
      Uri.parse('${Constants.cartUrl}/${product.code}/add'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }

  Future<void> removeProductFromCart(Product product) async {
    NotificationService.insert(Notification(
      title: 'Panier',
      content: 'Produit ${product.name} retiré du panier',
    ));
    await delete(
      Uri.parse('${Constants.cartUrl}/${product.code}'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }

  Future<void> resetCart() async {
    NotificationService.insert(const Notification(
      title: 'Panier',
      content: 'Panier réinitialisé',
    ));
    await put(
      Uri.parse(Constants.cartUrl),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }
}
