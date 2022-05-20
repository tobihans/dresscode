import 'package:bottom_sheet/bottom_sheet.dart';
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
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

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
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: Text(
                          'Proceed to checkout',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: checkoutViewModel.cartProducts
                            .map(
                              (p) => Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ProductTile(
                                        product: p.key,
                                        productService:
                                            checkoutViewModel.productService,
                                        wishlistService:
                                            checkoutViewModel.wishlistService,
                                        cartService:
                                            checkoutViewModel.cartService,
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
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              'Total : ${checkoutViewModel.totalPrice} XOF',
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //Button fill width
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      showFlexibleBottomSheet(
                        minHeight: 0,
                        initHeight: 0.5,
                        maxHeight: 0.75,
                        context: context,
                        builder: (BuildContext context,
                            ScrollController scrollController,
                            double bottomSheetOffset) {
                          return SafeArea(
                            child: Material(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 10.0),
                                child: ListView(
                                  controller: scrollController,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'INFORMATIONS',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10,
                                      ),
                                      child: TextFormField(
                                        controller:
                                            checkoutViewModel.nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10,
                                      ),
                                      child: TextFormField(
                                        controller:
                                            checkoutViewModel.emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10,
                                      ),
                                      child: TextFormField(
                                        controller:
                                            checkoutViewModel.addressController,
                                        decoration: const InputDecoration(
                                          labelText: 'Address',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your address';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10,
                                      ),
                                      child: TextFormField(
                                        controller: checkoutViewModel
                                            .addressZipController,
                                        decoration: const InputDecoration(
                                          labelText: 'Address Zip Code',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your address';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10,
                                      ),
                                      child: TextFormField(
                                        controller:
                                            checkoutViewModel.phoneController,
                                        decoration: const InputDecoration(
                                          labelText: 'Phone',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your phone';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10,
                                      ),
                                      child: TextFormField(
                                        controller:
                                            checkoutViewModel.countryController,
                                        decoration: const InputDecoration(
                                          labelText: 'Country',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your country';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 25,
                                      ),
                                      child: const Text(
                                        'PAYMENT METHOD -- CARD',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          //uppercase: true,
                                        ),
                                        //upperCase: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10,
                                      ),
                                      child: stripe.CardField(
                                        decoration: const InputDecoration(
                                          labelText: 'Card Number',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: checkoutViewModel
                                            .stripeCardController,
                                        onCardChanged: (card) {
                                          setState(() {
                                            checkoutViewModel.card = card;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size.fromHeight(50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () async {
                                          checkoutViewModel.initPayment();
                                        },
                                        child: checkoutViewModel.card != null
                                            ? const Text('Proceed to checkout')
                                            : const Text('Fill card details'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Proceed to checkout'),
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
  stripe.CardFieldInputDetails? card;

  //controllers
  final stripeCardController = stripe.CardEditController();
  //name controller, email controller, phone controller,address controller, adress zip, country controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final addressZipController = TextEditingController();
  final countryController = TextEditingController();

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

  initPayment() async {
    final paymentMethod = await stripe.Stripe.instance
        .createPaymentMethod(const stripe.PaymentMethodParams.card());
  }
}
