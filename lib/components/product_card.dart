import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/models/product.dart';
import 'package:flutter/material.dart';

/// TODO
class ProductCard extends StatelessWidget {
  // final Product product;
  // final ProductService productService;
  // final CartService cartService;
  // final WishlistService wishlistService;

  const ProductCard({
    Key? key,
    // required this.product,
    // required this.productService,
    // required this.cartService,
    // required this.wishlistService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 128.0,
              width: 128.0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: const DecorationImage(
                        image: NetworkImage(
                            "https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=10"),
                        fit: BoxFit.cover)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2.5, left: 2.5),
              child: const Text('Blablabla',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2.5, left: 2.5),
              child: const Text('2555 XOF'),
            ),
          ],
        ));
  }
}
