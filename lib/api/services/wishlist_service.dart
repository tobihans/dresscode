import 'dart:convert';

import 'package:dresscode/api/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/product.dart';

class WishlistService extends ApiBase {
  final String _token;

  WishlistService(this._token);

  Future<List<Product>> getWishlist() async {
    final apiResponse = await get(
      Uri.parse(Constants.wishlistUrl),
      Constants.emptyMap,
      '',
      _token,
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']) as List;
    return content
        .map((e) => Product.fromJson(e as String))
        .toList(growable: false);
  }

  Future<void> addToWishlist(Product productToAdd) async {
    await post(
      Uri.parse('${Constants.wishlistUrl}/${productToAdd.code}'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }

  Future<void> removeFromWishlist(Product productToRemove) async {
    await delete(
      Uri.parse('${Constants.wishlistUrl}/${productToRemove.code}'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }
}
