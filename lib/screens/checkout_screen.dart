import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/cart_widget.dart';
import 'package:dresscode/components/product_tile.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<CheckoutViewModel> init() async {
    final token = await TokenStorage.getToken();
    final cartService = CartService(token);
    final cart = await cartService.getCart();
    final cartProducts = <Product, int>{};
    for (var product in cart) {
      cartProducts[product] = (cartProducts[product] ?? 0) + 1;
    }
    final products = cartProducts.keys
        .map((e) => ProductAndQuantity(e, cartProducts[e]!))
        .toList();
    return CheckoutViewModel(
      productService: ProductService(),
      cartService: cartService,
      wishlistService: WishlistService(token),
      cartProducts: products,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      body: FutureBuilder<CheckoutViewModel>(
        future: init(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final checkoutViewModel = snapshot.data!;
            return ListView(
              children: <Widget>[
                const Text('Paiement'),
                Column(
                  children: <Widget>[
                    for (final p in checkoutViewModel.cartProducts)
                      Row(
                        children: [
                          ProductTile(
                            product: p.key,
                            productService: checkoutViewModel.productService,
                            wishlistService: checkoutViewModel.wishlistService,
                            cartService: checkoutViewModel.cartService,
                          ),
                          Text(p.value.toString())
                        ],
                      ),
                    // TODO finish this screen
                  ],
                ),
              ],
            );
          } else {
            return Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3,
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Une erreur s\'est produite',
                      style: TextStyle(fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class CheckoutViewModel {
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;
  final List<ProductAndQuantity> cartProducts;

  CheckoutViewModel({
    required this.productService,
    required this.cartService,
    required this.wishlistService,
    required this.cartProducts,
  });
}
