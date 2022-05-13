import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/image.dart' as img;
import 'package:dresscode/screens/product_screen.dart';
import 'package:dresscode/utils/list_extensions.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;
  final Widget? trailing;
  final double? width;

  const ProductCard({
    Key? key,
    required this.product,
    required this.productService,
    required this.cartService,
    required this.wishlistService,
    this.trailing,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width / 8,
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductScreen(
                    product: product,
                    productService: productService,
                    wishlistService: wishlistService,
                    cartService: cartService,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage(
                placeholder: Image.asset(
                  'assets/loading.gif',
                  fit: BoxFit.fill,
                ).image,
                imageErrorBuilder: (_, __, ___) {
                  return Image.asset(
                    'assets/placeholder.png',
                    fit: BoxFit.fill,
                    scale: 40.0,
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
          Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            width: double.infinity,
            child: Text(
              '${product.price} XOF',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
