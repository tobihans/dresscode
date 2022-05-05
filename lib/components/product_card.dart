import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/models/product.dart';
import 'package:flutter/material.dart';

/// TODO
class ProductCard extends StatelessWidget {
  final Product product;
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;
  final Widget? trailing;

  const ProductCard({
    Key? key,
    required this.product,
    required this.productService,
    required this.cartService,
    required this.wishlistService,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Text('ProductCard'),
    );
  }
}
