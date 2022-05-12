import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    Key? key
  }) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  Future<ShopViewModel> _initData() async {
    final token = await TokenStorage.getToken();
    final productService = ProductService(token);
    final wishlistService = WishlistService(token);
    final cartService = CartService(token);
    final wishlist = await wishlistService.getWishlist();
    return ShopViewModel(
      productService: productService,
      cartService: cartService,
      wishlistService: wishlistService,
    );
  }


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return const Scaffold(
      appBar: OwnAppBar(),
      drawer: AppDrawer(),
      floatingActionButton: FloatingBtn(),
      body: Material(),
    );
  }
}

class ShopViewModel{
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;

  ShopViewModel({
    required this.productService,
    required this.cartService,
    required this.wishlistService
  });
}
