import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/cart_widget.dart';
import 'package:dresscode/components/checkout_form.dart';
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
  late Future<CheckoutViewModel> _checkoutViewModelFuture;

  @override
  void initState() {
    _checkoutViewModelFuture = CheckoutViewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          _checkoutViewModelFuture = CheckoutViewModel.init();
        },
        child: FutureBuilder<CheckoutViewModel>(
          future: _checkoutViewModelFuture,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        'Paiement',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  Column(
                    children: checkoutViewModel.cartProducts
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ProductTile(
                                    product: p.key,
                                    productService:
                                        checkoutViewModel.productService,
                                    wishlistService:
                                        checkoutViewModel.wishlistService,
                                    cartService: checkoutViewModel.cartService,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Text(
                                    '(${p.value})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total : ${checkoutViewModel.totalPrice} XOF',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 25,
                    ),
                    child: CheckoutForm(
                      onCheckout: (_, __, ___) async {},
                    ),
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
      ),
    );
  }
}

class CheckoutViewModel {
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;
  final List<ProductAndQuantity> cartProducts;
  final int totalPrice;

  CheckoutViewModel({
    required this.productService,
    required this.cartService,
    required this.wishlistService,
    required this.cartProducts,
    required this.totalPrice,
  });

  static Future<CheckoutViewModel> init() async {
    final token = await TokenStorage.getToken();
    final cartService = CartService(token);
    final cart = await cartService.getCart();
    final cartProducts = <Product, int>{};
    for (final product in cart) {
      cartProducts[product] = (cartProducts[product] ?? 0) + 1;
    }
    final products = cartProducts.keys
        .map((e) => ProductAndQuantity(e, cartProducts[e]!))
        .toList();
    final cartTotal = products.fold(0, (int previousValue, element) {
      return previousValue + element.key.price * element.value;
    });
    return CheckoutViewModel(
      productService: ProductService(),
      cartService: cartService,
      wishlistService: WishlistService(token),
      cartProducts: products,
      totalPrice: cartTotal,
    );
  }

  createPaymentCard() {}
}
