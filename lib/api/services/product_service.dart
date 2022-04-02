import 'dart:convert';

import 'package:dresscode/api/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/category.dart';
import 'package:dresscode/models/page.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/requests/page_request.dart';

class ProductService extends ApiBase {
  final String _token;

  ProductService(this._token);

  Future<Page<Product>> getProducts(PageRequest pageRequest) async {
    final apiResponse = await get(
      Uri.parse(Constants.productsUrl),
      pageRequest.toMap(),
      '',
      _token,
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content);
  }

  Future<Page<Product>> getRelatedProducts(
      PageRequest pageRequest, Product product) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/${product.code}/related'),
      pageRequest.toMap(),
      '',
      _token,
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content);
  }

  Future<Page<Product>> findProductsByName(
      PageRequest pageRequest, String name) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/search/$name'),
      pageRequest.toMap(),
      '',
      _token,
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content);
  }

  Future<Page<Product>> findProductsByCategory(
      PageRequest pageRequest, Category category) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/category/${category.name}'),
      pageRequest.toMap(),
      '',
      _token,
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content);
  }

  Future<Product> getProduct(String code) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/$code'),
      Constants.emptyMap,
      '',
      _token,
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Product.fromJson(content);
  }
}
