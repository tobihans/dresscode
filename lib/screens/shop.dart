import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/product_card.dart';
import 'package:dresscode/models/page.dart' as page;
import 'package:dresscode/requests/page_request.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/product.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          builder: (context, AsyncSnapshot<ShopViewModel> snapshot) {
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
                child: (snapshot.data?.products.isNotEmpty ?? false)
                    ? StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          for (Product p in snapshot.data!.products)
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
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )
                    : const Center(
                        child: Text('Aucun produit'),
                      ),
              );
            }
            return Container();
          },
          future: _initData(),
        ),
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

  ShopViewModel(
      {required this.productService,
      required this.cartService,
      required this.wishlistService}) {
    pageRequest = PageRequest(pageNumber: 0, pageSize: 20);
  }

  Future<void> getProducts() async {
    var response = await productService.getProducts(pageRequest);
    products.addAll(response.content);
  }

  Future<page.Page<Product>> execute() async {
    return await productService.getProducts(pageRequest);
  }

  Future<List<Product>> viewMore() async {
    pageRequest.pageNumber++;
    return (await execute()).content;
  }
}
