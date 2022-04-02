import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/transparent_image.dart';
import 'package:flutter/material.dart';

// TODO : test this component
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
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.fromSize(
              size: const Size.fromRadius(40),
              child: FadeInImage.memoryNetwork(
                placeholder: transparentImage,
                image: product.images?.first.url ?? '',
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 17),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Nbre : $number'),
                    Text('Sous total : ${number * product.price} XOF')
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
