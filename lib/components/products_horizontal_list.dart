import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/product_card.dart';
import 'package:dresscode/models/product.dart';
import 'package:flutter/material.dart';

class ProductsHorizontalList extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onProductSelected;
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;

  const ProductsHorizontalList({
    Key? key,
    required this.products,
    required this.onProductSelected,
    required this.productService,
    required this.cartService,
    required this.wishlistService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ProductCard(
            productService: productService,
            cartService: cartService,
            wishlistService: wishlistService,
            product: products[index],
          ),
        );
      },
    );
  }
}
