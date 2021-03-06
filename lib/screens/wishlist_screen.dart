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
  late Future<WishlistScreenViewModel> _wishlistScreenViewModelFuture;

  @override
  void initState() {
    _wishlistScreenViewModelFuture = WishlistScreenViewModel.init();
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() {
      _wishlistScreenViewModelFuture = WishlistScreenViewModel.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<WishlistScreenViewModel>(
          future: _wishlistScreenViewModelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final viewModel = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: (viewModel.wishlist.isNotEmpty)
                    ? StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          for (Product p in viewModel.wishlist)
                            Card(
                              elevation: 10,
                              borderOnForeground: true,
                              child: Wrap(
                                children: [
                                  ProductCard(
                                    product: p,
                                    productService: viewModel.productService,
                                    cartService: viewModel.cartService,
                                    wishlistService: viewModel.wishlistService,
                                    width: double.infinity,
                                    trailing: IconButton(
                                      onPressed: () async {
                                        try {
                                          await viewModel.wishlistService
                                              .removeFromWishlist(p);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Produit retir?? de la liste de souhaits',
                                              ),
                                            ),
                                          );
                                          await _refresh();
                                        } on Exception {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Une erreur s\'est produite',
                                              ),
                                              backgroundColor: colorScheme.error,
                                            ),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: colorScheme.primary,
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
            return const Center(
              child: Text('Une erreur s\'est produite'),
            );
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

  const WishlistScreenViewModel({
    required this.productService,
    required this.cartService,
    required this.wishlistService,
    required this.wishlist,
  });

  static Future<WishlistScreenViewModel> init() async {
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
}
