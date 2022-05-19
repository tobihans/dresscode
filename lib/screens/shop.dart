import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/product_card.dart';
import 'package:dresscode/requests/page_request.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Product> product = [];
  ShopViewModel? shopViewModel;
  bool loading = false;

  Future<ShopViewModel> _initData() async {
    final token = await TokenStorage.getToken();
    final productService = ProductService();
    final wishlistService = WishlistService(token);
    final cartService = CartService(token);
    final viewModel = ShopViewModel(
      productService: productService,
      cartService: cartService,
      wishlistService: wishlistService,
    );
    await viewModel.getProducts();
    return viewModel;
  }

  @override
  void initState() {
    _initData().then(
      (value) => setState(() {
        shopViewModel = value;
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: (shopViewModel != null)
          ? RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if (scrollNotification.metrics.pixels > 0) {
                      if (shopViewModel!.canLoadMore) {
                        setState(() {
                          shopViewModel!.loadingMore = true;
                          shopViewModel!.pageRequest.pageNumber++;
                        });
                        shopViewModel!.viewMore().then((value) => {
                              setState(() {
                                if (value.isNotEmpty) {
                                  shopViewModel!.products.addAll(value);
                                } else {
                                  shopViewModel!.canLoadMore = false;
                                }
                                shopViewModel!.loadingMore = false;
                              })
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Il ne reste plus de produit'),
                          ),
                        );
                      }
                    }
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  padding: const EdgeInsets.all(10),
                  child: (shopViewModel!.products.isNotEmpty)
                      ? Column(
                          children: [
                            StaggeredGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: [
                                for (Product p in shopViewModel!.products)
                                  Card(
                                    elevation: 10,
                                    borderOnForeground: true,
                                    child: Wrap(
                                      children: [
                                        ProductCard(
                                          product: p,
                                          productService:
                                              shopViewModel!.productService,
                                          cartService:
                                              shopViewModel!.cartService,
                                          wishlistService:
                                              shopViewModel!.wishlistService,
                                          width: double.infinity,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            if (shopViewModel!.loadingMore)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        )
                      : const Center(
                          child: Text('Aucun produit'),
                        ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ShopViewModel {
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;
  late PageRequest pageRequest;
  List<Product> products = [];
  bool loadingMore = false;
  bool canLoadMore = true;

  ShopViewModel({
    required this.productService,
    required this.cartService,
    required this.wishlistService,
  }) {
    pageRequest = PageRequest(pageNumber: 0, pageSize: 20);
  }

  Future<void> getProducts() async {
    final response = await productService.getProducts(pageRequest);
    products.addAll(response.content);
  }

  Future<List<Product>> viewMore() async {
    return (await productService.getProducts(pageRequest)).content;
  }
}
