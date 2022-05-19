import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/category.dart';
import 'package:dresscode/models/page.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/requests/page_request.dart';

class ProductService extends ApiBase {
  ProductService();

  Future<Page<Product>> getProducts(PageRequest pageRequest) async {
    final apiResponse = await get(
      Uri.parse(Constants.productsUrl),
      queryParams: pageRequest.toMap(),
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content);
  }

  Future<List<Product>> getRelatedProducts(
    PageRequest pageRequest,
    Product product,
  ) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/${product.code}/related'),
      queryParams: pageRequest.toMap(),
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content).content;
  }

  Future<Page<Product>> findProductsByName(
    PageRequest pageRequest,
    String name,
  ) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/search/$name'),
      queryParams: pageRequest.toMap(),
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content);
  }

  Future<Page<Product>> findProductsByCategory(
    PageRequest pageRequest,
    Category category,
  ) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/category/${category.name}'),
      queryParams: pageRequest.toMap(),
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Product>.fromJson(content);
  }

  Future<Product> getProduct(String code) async {
    final apiResponse = await get(
      Uri.parse('${Constants.productsUrl}/$code'),
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Product.fromJson(content);
  }
}
