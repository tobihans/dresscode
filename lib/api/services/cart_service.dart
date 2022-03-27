import 'dart:convert';

import 'package:dresscode/api/api_base.dart';
import 'package:dresscode/api/core/constants.dart';

import 'package:dresscode/models/product.dart';

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
    final content =
        jsonEncode(jsonDecode(apiResponse)['content']) as Map<String, dynamic>;
    return (content['products'] as List)
        .map((e) => Product.fromJson(e as String))
        .toList(growable: false);
  }

  Future<void> addProductToCart(Product product) async {
    await post(
      Uri.parse('${Constants.cartUrl}/${product.code}/add'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }

  Future<void> removeProductFromCart(Product product) async {
    await delete(
      Uri.parse('${Constants.cartUrl}/${product.code}'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }

  Future<void> resetCart() async {
    await put(
      Uri.parse(Constants.cartUrl),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }
}
