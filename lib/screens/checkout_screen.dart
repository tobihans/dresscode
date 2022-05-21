import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/payment_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/cart_widget.dart';
import 'package:dresscode/components/product_tile.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/requests/payment_request.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:dresscode/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final stripeCardController = stripe.CardEditController();
  final addressController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  late Future<CheckoutViewModel> _checkoutViewModelFuture;

  @override
  void initState() {
    _checkoutViewModelFuture = CheckoutViewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    stripeCardController.dispose();
    addressController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    super.dispose();
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
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: Text(
                          'Procéder au paiement',
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                            top: 20,
                            bottom: 10,
                          ),
                          child: const Text(
                            'Informations de paiement',
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
                            controller: addressController,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                              labelText: 'Adresse',
                              border: OutlineInputBorder(),
                            ),
                            validator: Validator.validateNotEmpty(
                              'Adresse',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10,
                          ),
                          child: TextFormField(
                            controller: zipCodeController,
                            decoration: const InputDecoration(
                              labelText: 'Code postal',
                              border: OutlineInputBorder(),
                            ),
                            validator: Validator.validateNotEmpty(
                              'Code postal',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10,
                          ),
                          child: TextFormField(
                            controller: countryController,
                            decoration: const InputDecoration(
                              labelText: 'Pays',
                              border: OutlineInputBorder(),
                            ),
                            validator: Validator.validateNotEmpty(
                              'Pays',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10,
                          ),
                          child: stripe.CardField(
                            decoration: const InputDecoration(
                              labelText: 'Numéro de carte',
                              border: OutlineInputBorder(),
                            ),
                            controller: stripeCardController,
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
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: loading
                                ? null
                                : () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      setState(() {
                                        loading = true;
                                      });
                                      try {
                                        await checkoutViewModel.initPayment(
                                          addressZip: zipCodeController.text,
                                        );
                                        final token =
                                            await TokenStorage.getToken();
                                        await CartService(token).resetCart();
                                        Navigator.pushNamed(
                                          context,
                                          Routes.home,
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Paiement effectué avec succès',
                                              ),
                                              content: const Text(
                                                'Félicitations. Votre achat a été effectué avec succès',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      Routes.profile,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Voir mes achats',
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pushNamed(
                                                      context,
                                                      Routes.shop,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Aller à la boutique',
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } catch (_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Une erreur s\'est produite',
                                            ),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                        );
                                      } finally {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    }
                                  },
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('Payer'),
                          ),
                        ),
                      ],
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
  stripe.CardFieldInputDetails? card;

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

  Future<void> initPayment({
    required String addressZip,
  }) async {
    const platform = MethodChannel('com.example.dresscode/ip');
    final user = (await AuthService.getUserFromTokenStorage())!;
    final paymentMethod = await stripe.Stripe.instance.createPaymentMethod(
      stripe.PaymentMethodParams.card(
        billingDetails: stripe.BillingDetails(
          name: user.name,
          email: user.email,
          phone: user.phone,
        ),
      ),
    );
    final paymentService = PaymentService(await TokenStorage.getToken());
    await paymentService.makePayment(
      PaymentRequest(
        id: paymentMethod.id,
        created: (DateTime.now().millisecondsSinceEpoch / 1000).truncate(),
        object: 'card',
        livemode: paymentMethod.livemode,
        clientIp: await platform.invokeMethod('getIp'),
        type: paymentMethod.type,
        used: false,
        price: totalPrice,
        productsCode:
            cartProducts.map((e) => e.key.code!).toList(growable: false),
        card: PaymentCard(
          id: paymentMethod.id,
          country: paymentMethod.card.country!,
          object: 'card',
          brand: paymentMethod.card.brand!,
          expMonth: paymentMethod.card.expMonth!,
          expYear: paymentMethod.card.expYear!,
          addressZip: addressZip,
          funding: paymentMethod.card.funding!,
          last4: paymentMethod.card.last4!,
          dynamicLast4: paymentMethod.card.last4!,
          cvcCheck: '',
        ),
      ),
    );
  }
}
