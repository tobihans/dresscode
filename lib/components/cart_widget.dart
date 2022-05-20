import 'package:dresscode/api/core/api_http_exception.dart';
import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/components/product_cart_widget.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

typedef ProductAndQuantity = MapEntry<Product, int>;

class CartWidget extends StatefulWidget {
  final ScrollController scrollController;

  const CartWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  late Future<List<ProductAndQuantity>> _cartProductsFuture;
  CartService? _cartService;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _cartProductsFuture = _initCartProducts();
  }

  Future<void> clearCart() async {
    await _cartService!.resetCart();
    setState(() {
      _cartProductsFuture = _initCartProducts();
    });
  }

  Future<List<ProductAndQuantity>> _initCartProducts() async {
    _cartService ??= CartService(await TokenStorage.getToken());
    final cart = await _cartService!.getCart();
    final cartProducts = <Product, int>{};
    for (var product in cart) {
      cartProducts[product] = (cartProducts[product] ?? 0) + 1;
    }
    return cartProducts.keys
        .map((e) => ProductAndQuantity(e, cartProducts[e]!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductAndQuantity>>(
      future: _cartProductsFuture,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          final cartProductsList = snapshot.data!;
          if (cartProductsList.isEmpty) {
            return const Center(
              child: Text(
                'Aucun produit',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final cartTotal =
              cartProductsList.fold(0, (int previousValue, element) {
            return previousValue + element.key.price * element.value;
          });

          return Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Text(
                              'Panier',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '$cartTotal XOF',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.topRight,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              _loading = true;
                            });
                            await clearCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Panier vidé avec succès',
                                ),
                              ),
                            );
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Une erreur s\'est produite',
                                ),
                              ),
                            );
                          } finally {
                            setState(() {
                              _loading = false;
                            });
                          }
                        },
                        icon: _loading
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.delete_forever),
                      ),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 10),
              ),
              Container(
                child: const Center(
                  child: Text(
                    'Glisser vers la gauche pour retirer et vers la droite pour ajouter.',
                  ),
                ),
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 35,
                  left: 10,
                  right: 10,
                ),
              ),
              Flexible(
                child: ListView.separated(
                  itemCount: cartProductsList.length,
                  controller: widget.scrollController,
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      child: ProductCartWidget(
                        product: cartProductsList[index].key,
                        number: cartProductsList[index].value,
                      ),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          try {
                            _cartService!.removeProductFromCart(
                              cartProductsList[index].key,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Produit retiré du panier',
                                ),
                              ),
                            );
                            setState(() {});
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Échec du retrait du produit',
                                ),
                              ),
                            );
                          }
                        } else if (direction == DismissDirection.startToEnd) {
                          try {
                            _cartService!.addProductToCart(
                              cartProductsList[index].key,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Produit ajouté au panier',
                                ),
                              ),
                            );
                            setState(() {});
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Échec de l\'ajout du produit',
                                ),
                              ),
                            );
                          }
                        }
                        setState(() {
                          _cartProductsFuture = _initCartProducts();
                        });
                      },
                      background: Container(
                        color: Colors.green,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 15),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return const Divider();
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.checkout);
                  },
                  child: const Text('Passer au paiement'),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          if (snapshot is ApiHttpException) {
            Logger.root.severe((snapshot.error as ApiHttpException).toString());
          }
          return const Center(
            child: Text(
              'Une erreur s\'est produite 🥲',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
