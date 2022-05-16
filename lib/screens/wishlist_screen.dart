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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    final productService = ProductService();
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: _initData(),
          builder: (context, AsyncSnapshot<WishlistScreenViewModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Une erreur est survenue'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: (snapshot.data?.wishlist.isNotEmpty ?? false)
                    ? StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          for (Product p in snapshot.data!.wishlist)
                            Card(
                              elevation: 10,
                              borderOnForeground: true,
                              child: Wrap(
                                children: [
                                  ProductCard(
                                    product: p,
                                    productService:
                                        snapshot.data!.productService,
                                    cartService: snapshot.data!.cartService,
                                    wishlistService:
                                        snapshot.data!.wishlistService,
                                    width: double.infinity,
                                    trailing: IconButton(
                                      onPressed: () async {
                                        try {
                                          await snapshot.data!.wishlistService
                                              .removeFromWishlist(p);
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Produit retiré de la liste de souhaits',
                                              ),
                                            ),
                                          );
                                        } on Exception {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Une erreur s\'est produite',
                                              ),
                                              backgroundColor:
                                                  Theme.of(context).errorColor,
                                            ),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'Aucun produit',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
              );
            }
            return Container();
          },
        ),
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
