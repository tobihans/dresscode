import 'dart:convert';

import 'package:dresscode/api/core/api_base.dart';
import 'package:dresscode/api/core/constants.dart';
import 'package:dresscode/models/comment.dart';
import 'package:dresscode/models/page.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/requests/comment_request.dart';
import 'package:dresscode/requests/page_request.dart';

class CommentService extends ApiBase {
  final String _token;

  CommentService(this._token);

  Future<Page<Comment>> getComments(
    PageRequest pageRequest,
    Product product,
  ) async {
    final apiResponse = await get(
      Uri.parse('${Constants.commentsUrl}/${product.code}/comments'),
      queryParams: pageRequest.toMap(),
      token: _token,
    );
    final content = jsonEncode(jsonDecode(apiResponse)['content']);
    return Page<Comment>.fromJson(content);
  }

  Future<Comment> postComment(CommentRequest commentRequest) async {
    final commentPostResponse = await post(
      Uri.parse(Constants.commentsUrl),
      data: commentRequest.toJson(),
      token: _token,
    );
    final content = jsonEncode(jsonDecode(commentPostResponse)['content']);
    return Comment.fromJson(content);
  }
}
