import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/product_card.dart';
import 'package:dresscode/requests/page_request.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';
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
    return ShopViewModel(
      productService: productService,
      cartService: cartService,
      wishlistService: wishlistService,
    );
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
      body: FutureBuilder(
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
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (snapshot.data?.products.isNotEmpty ?? false)
                      ListView.builder(
                          itemBuilder: (context, index) {
                            final product = snapshot.data!.products[index];
                            return ProductCard(
                              product: product,
                              productService: snapshot.data!.productService,
                              cartService: snapshot.data!.cartService,
                              wishlistService: snapshot.data!.wishlistService,
                            );
                          },
                          itemCount: snapshot.data!.products.length)
                    else
                      const Center(
                        child: Text('Aucun produit'),
                      ),
                  ]),
            );
          },
          future: _initData()),
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
    getProducts();
  }

  getProducts() async {
    var response = await productService.getProducts(pageRequest);
    products.addAll(response.content);
  }

  viewMore() async {
    pageRequest.pageNumber++;
    getProducts();
  }
}
