import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/category.dart';
import 'package:dresscode/models/page.dart';
import 'package:dresscode/requests/page_request.dart';

class CategoryService extends ApiBase {
  CategoryService();

  Future<Page<Category>> getCategories(PageRequest pageRequest) async {
    final apiResponse = await get(
      Uri.parse(Constants.categoriesUrl),
      queryParams: pageRequest.toMap(),
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Category>.fromJson(content);
  }
}
