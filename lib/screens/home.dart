import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/category_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/products_horizontal_list.dart';
import 'package:dresscode/models/category.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/requests/page_request.dart';
import 'package:dresscode/screens/product_screen.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/home_hero.dart';
import 'package:dresscode/components/category_widget.dart';

import 'package:dresscode/api/services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<HomeViewModel> _homeViewModelFuture;

  @override
  void initState() {
    super.initState();
    _homeViewModelFuture = HomeViewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: RefreshIndicator(
        onRefresh: () async {
          initState();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const HomeHero(
                text: 'Visiter notre collection',
              ),
            ),
            FutureBuilder<HomeViewModel>(
              future: _homeViewModelFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  final homeViewModel = snapshot.data!;
                  return Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 14.0,bottom: 10),
                        child: const Text(
                          'Les cat??gories',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 10,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeViewModel.categories.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: CategoryWidget(
                                category: homeViewModel.categories[index],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0,bottom: 10),
                        child: const Text(
                          'Les articles phares',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: size.height / 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ProductsHorizontalList(
                            onProductSelected: (Product product) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                    product: product,
                                    productService: homeViewModel.productService,
                                    cartService: homeViewModel.cartService,
                                    wishlistService:
                                        homeViewModel.wishlistService,
                                  ),
                                ),
                              );
                            },
                            products: homeViewModel.bestProducts.sublist(
                              0,
                              (homeViewModel.bestProducts.length > 10)
                                  ? 11
                                  : null,
                            ),
                            productService: homeViewModel.productService,
                            cartService: homeViewModel.cartService,
                            wishlistService: homeViewModel.wishlistService,
                          ),
                        ),
                      ),
                      if(homeViewModel.bestProducts.length > 10)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: size.height / 3),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ProductsHorizontalList(
                              onProductSelected: (Product product) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      product: product,
                                      productService: homeViewModel.productService,
                                      cartService: homeViewModel.cartService,
                                      wishlistService:
                                      homeViewModel.wishlistService,
                                    ),
                                  ),
                                );
                              },
                              products: homeViewModel.bestProducts.sublist(11),
                              productService: homeViewModel.productService,
                              cartService: homeViewModel.cartService,
                              wishlistService: homeViewModel.wishlistService,
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _homeViewModelFuture = HomeViewModel.init();
                        });
                      },
                      child: const Text(
                        'Une erreur s\'est produite, toucher pour r????ssayer',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeViewModel {
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;
  final List<Category> categories;
  final List<Product> bestProducts;

  const HomeViewModel({
    required this.productService,
    required this.cartService,
    required this.wishlistService,
    required this.bestProducts,
    required this.categories,
  });

  static Future<HomeViewModel> init() async {
    final token = await TokenStorage.getToken();
    final wishlistService = WishlistService(token);
    final cartService = CartService(token);
    final categoryService = CategoryService();
    final categoriesPage = await categoryService.getCategories(
      PageRequest(
        pageNumber: 0,
        pageSize: 35,
      ),
    );
    final productService = ProductService();
    final products = await productService.getProducts(
      PageRequest(
        pageNumber: 0,
        pageSize: 20,
      ),
    );
    return HomeViewModel(
      productService: productService,
      cartService: cartService,
      wishlistService: wishlistService,
      categories: categoriesPage.content,
      bestProducts: products.content,
    );
  }
}
