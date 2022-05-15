import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/image.dart' as img;
import 'package:dresscode/utils/list_extensions.dart';
import 'package:flutter/material.dart';

class ProductCartWidget extends StatelessWidget {
  const ProductCartWidget({
    Key? key,
    required this.product,
    required this.number,
  }) : super(key: key);

  final Product product;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(40),
                child: FadeInImage(
                  placeholder: Image.asset(
                    'assets/loading.gif',
                    fit: BoxFit.fill,
                  ).image,
                  imageErrorBuilder: (_, __, ___) {
                    return Image.asset(
                      'assets/placeholder.png',
                      fit: BoxFit.fill,
                    );
                  },
                  image: Image.network(
                    product.images.firstOrDefaultAndApply(
                      const img.Image(url: ''),
                      (i) => i.url,
                    ),
                    fit: BoxFit.fill,
                    errorBuilder: (ctx, obj, stack) {
                      return Image.asset(
                        'assets/placeholder.png',
                        fit: BoxFit.fill,
                      );
                    },
                  ).image,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Nbre : $number'),
                    const Spacer(),
                    Text('Sous total : ${number * product.price} XOF'),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
