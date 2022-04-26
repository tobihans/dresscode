import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/notification.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/notification_service.dart';

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

  Future<bool> isInWishlist(Product product) async {
    final apiResponse = await get(
      Uri.parse('${Constants.wishlistUrl}/${product.code}'),
      Constants.emptyMap,
      '',
      _token,
    );
    return (jsonDecode(apiResponse)['content']) as bool;
  }

  Future<void> addToWishlist(Product productToAdd) async {
    NotificationService.insert(Notification(
      title: 'Liste de souhaits',
      content: 'Produit ${productToAdd.name} ajouté à la liste de souhaits',
    ));
    await post(
      Uri.parse('${Constants.wishlistUrl}/${productToAdd.code}'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }

  Future<void> removeFromWishlist(Product productToRemove) async {
    NotificationService.insert(Notification(
      title: 'Liste de souhaits',
      content: 'Produit ${productToRemove.name} retiré de la liste de souhaits',
    ));
    await delete(
      Uri.parse('${Constants.wishlistUrl}/${productToRemove.code}'),
      jsonEncode(Constants.emptyMap),
      _token,
    );
  }
}
