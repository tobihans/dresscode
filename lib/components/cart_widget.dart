import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/components/product_cart_widget.dart';
import 'package:dresscode/models/image.dart' as Img;
import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CartWidget extends StatefulWidget {
  final ScrollController scrollController;

  const CartWidget({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  late Future<List<MapEntry<Product, int>>> _cartProductsFuture;
  CartService? _cartService;

  @override
  void initState() {
    super.initState();
    _cartProductsFuture = _initCartProducts();
  }

  Future<List<MapEntry<Product, int>>> _initCartProducts() async {
    // TODO : swap for the real one
    // _cartService ??= CartService(await TokenStorage.getToken());
    // final cart = await _cartService!.getCart();
    final cart = [];
    for (var i = 0; i < 10; ++i) {
      cart.add(
        Product(
          code: i.toString(),
          name: 'Product $i',
          description: 'Ceci est le produit $i',
          price: i * 1000,
          images: [
            Img.Image(
              code: i.toString(),
              url:
                  'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Fencrypted-tbn0.gstatic.com%2Fimages%3Fq%3Dtbn%3AANd9GcSH9n3HloOF80XIFHqOXKlI_71fd313vGyKCRS71wOjT4095Qk6%26s&sp=1648911173T297040ad5602229c6a25ba6fa65928fa81a98643e60ac263cdbed6a0de9af39f',
            )
          ],
        ),
      );
    }

    final cartProducts = <Product, int>{};
    for (var product in cart) {
      cartProducts[product] = cartProducts[product] ?? 0 + 1;
    }
    return cartProducts.keys.map((e) => MapEntry(e, cartProducts[e]!)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MapEntry<Product, int>>>(
      future: _cartProductsFuture,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          final cartProductsList = snapshot.data!;
          if (cartProductsList.isEmpty) {
            return const Center(
              child: Text(
                'Aucune notification',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final cartTotal = cartProductsList.fold(0, (previousValue, element) {
            return (previousValue as int) + element.key.price * element.value;
          });

          return Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panier',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      child: Text(
                        '$cartTotal XOF',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.topRight,
                    )
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
            ],
          );
        } else if (snapshot.hasError) {
          Logger.root.severe((snapshot.error as Error).stackTrace);
          return const Center(
            child: Text(
              'Une erreur s\'est produite 🥲',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Color(CustomColors.raw['primary']!),
          ),
        );
      },
    );
  }
}
