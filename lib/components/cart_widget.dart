import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/components/product_cart_widget.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';

// TODO : test this component
// TODO : connect with fab click
class CartWidget extends StatefulWidget {
  const CartWidget({Key? key}) : super(key: key);

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
    _cartService ??= CartService(await TokenStorage.getToken());
    final cart = await _cartService!.getCart();
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
                child: Center(
                  child: Text(
                    'Panier ($cartTotal}) XOF',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(top: 10),
              ),
              Container(
                child: const Center(
                  child: Text(
                    'Glisser vers la gauche pour retirer et vers la droite pour ajouter.',
                  ),
                ),
                margin: const EdgeInsets.only(top: 10, bottom: 35),
              ),
              Flexible(
                child: ListView.separated(
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      child: ProductCartWidget(
                        product: cartProductsList[index].key,
                        number: cartProductsList[index].value,
                      ),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          _cartService!.removeProductFromCart(
                            cartProductsList[index].key,
                          );
                        } else if (direction == DismissDirection.startToEnd) {
                          _cartService!.addProductToCart(
                            cartProductsList[index].key,
                          );
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
                        alignment: Alignment.centerRight,
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
                  itemCount: cartProductsList.length,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
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
