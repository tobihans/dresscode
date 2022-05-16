import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/search_product_item.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/page.dart' as page;
import 'package:dresscode/requests/page_request.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchScreen> {
  static const int _pageSize = 10;
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();
  String token = '';
  String _search = '';
  late Future<page.Page<Product>> _productsFuture;

  void onSearch(String value) {
    _search = _searchController.text;
    setState(() {
      _productsFuture = get();
    });
  }

  void onClear() {
    _search = '';
    _searchController.clear();
    setState(() {});
  }

  Future<void> previous() async {
    setState(() {
      --_currentPage;
      _productsFuture = get();
    });
  }

  Future<void> next() async {
    setState(() {
      ++_currentPage;
      _productsFuture = get();
    });
  }

  Future<page.Page<Product>> get() async {
    token = await TokenStorage.getToken();
    return await _productService.findProductsByName(
      PageRequest(
        pageNumber: _currentPage,
        pageSize: _pageSize,
      ),
      _search,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /// Trick to load zero products asynchronously
    _productsFuture = Future.delayed(
      Duration.zero,
      () => page.emptyPage<Product>(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onBackground,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: colorScheme.onSurface),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Recherche ...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: onClear,
                    ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          onClear();
        },
        child: FutureBuilder<page.Page<Product>>(
          future: _productsFuture,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              final productPage = snapshot.data!;
              if (productPage.content.isEmpty) {
                return const Center(
                  child: Text('Aucun produit'),
                );
              } else {
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: <Widget>[
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      itemCount: productPage.content.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final product = productPage.content[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: SearchProductItem(
                            product: product,
                            productService: _productService,
                            cartService: CartService(token),
                            wishlistService: WishlistService(token),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // if (productPage.number > 0)
                        IconButton(
                          onPressed: previous,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        IconButton(
                          onPressed: next,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ],
                );
              }
            } else {
              return Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3,
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Une erreur s\'est produite',
                        style: TextStyle(fontSize: 17),
                      ),
                      TextButton(
                        onPressed: onClear,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
