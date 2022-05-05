import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/product_card.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/api/services/wishlist_service.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  Future<WishlistScreenViewModel> _initData() async {
    final token = await TokenStorage.getToken();
    final productService = ProductService(token);
    final wishlistService = WishlistService(token);
    final cartService = CartService(token);
    final wishlist = await wishlistService.getWishlist();
    return WishlistScreenViewModel(
      productService: productService,
      cartService: cartService,
      wishlistService: wishlistService,
      wishlist: wishlist,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Mes souhaits',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          FutureBuilder<WishlistScreenViewModel>(
            future: _initData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final viewModel = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.wishlist.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = viewModel.wishlist[index];
                    return ProductCard(
                      product: product,
                      productService: viewModel.productService,
                      cartService: viewModel.cartService,
                      wishlistService: viewModel.wishlistService,
                      trailing: IconButton(
                        onPressed: () async {
                          try {
                            await viewModel.wishlistService
                                .removeFromWishlist(product);
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Produit retiré de la liste de souhaits',
                                ),
                              ),
                            );
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Une erreur s\'est produite'),
                                backgroundColor: Theme.of(context).errorColor,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Une erreur est survenue',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class WishlistScreenViewModel {
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;
  final List<Product> wishlist;

  WishlistScreenViewModel({
    required this.productService,
    required this.cartService,
    required this.wishlistService,
    required this.wishlist,
  });
}
