import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:dresscode/models/product.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({Key? key, required this.product}) : super(key: key);
  final Product product;

  //convert b64 to image
  Image imageFromBase64String(dynamic base64String) {
    return Image.memory(base64Decode(base64String));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        //TODO: REDIRECT BASED ON PAGE ACTION
      },

      leading: (product.images == null) ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Image(image: imageFromBase64String(product.images![0]).image)
      ) : const SizedBox(height: 1),

      contentPadding: const EdgeInsets.only(top: 0, left: 10, bottom: 0),

      title: Text(
        '${product.name} (${product.price} FCFA)',
        style: const TextStyle(color: Colors.black),
      ),

      subtitle: Text(
        product.description,
        style: const TextStyle(color: Colors.black54),
      ),

      //TODO: IN CASE OF WISHLIST
      /*trailing: SizedBox(
        width: 98,
        child: Row(
          children: [
            someIcon
          ],
        ),
      ),*/

    );
  }
}