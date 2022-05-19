import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/image.dart' as img;
import 'package:dresscode/screens/product_screen.dart';
import 'package:dresscode/utils/list_extensions.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;

  const ProductTile({
    Key? key,
    required this.product,
    required this.productService,
    required this.cartService,
    required this.wishlistService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: FadeInImage(
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
                    fit: BoxFit.cover,
                  ).image,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 12,
                  ),
                  child: Text(product.name),
                ),
              ],
            ),
            Text('${product.price} XOF'),
          ],
        ),
      ),
    );
  }
}
