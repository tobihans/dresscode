import 'package:dresscode/api/core/api_http_exception.dart';
import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/api/services/wishlist_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/image_widget_gallery.dart';
import 'package:dresscode/components/products_horizontal_list.dart';
import 'package:dresscode/components/wishlist_button.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/requests/page_request.dart';
import 'package:dresscode/utils/models_extensions.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final ProductService productService;
  final CartService cartService;
  final WishlistService wishlistService;

  const ProductScreen({
    Key? key,
    required this.product,
    required this.productService,
    required this.cartService,
    required this.wishlistService,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductService _productService;
  late CartService _cartService;
  late WishlistService _wishlistService;
  late Future<bool> _isInWishlistFuture;
  bool _isLoading = false;

  Future<void> addToCart(Product product) async {
    await _cartService.addProductToCart(widget.product);
  }

  Future<List<Product>> getRelatedProducts() async {
    return await _productService.getRelatedProducts(
      PageRequest(pageNumber: 0, pageSize: 10),
      widget.product,
    );
  }

  void fresh() {
    setState(() {
      _isInWishlistFuture = _wishlistService.isInWishlist(widget.product);
    });
  }

  @override
  void initState() {
    _productService = widget.productService;
    _cartService = widget.cartService;
    _wishlistService = widget.wishlistService;
    _isInWishlistFuture = _wishlistService.isInWishlist(widget.product);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productImages = widget.product.imageUrls;
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.5,
            child: ImageWidgetGallery(images: productImages),
          ),
          SizedBox(
            height: size.height * 0.03,
            child: null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await addToCart(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produit ajouté au panier'),
                      ),
                    );
                  } on ApiHttpException catch (e) {
                    if (e.isAuthException) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Vous devez être authentifié pour réaliser cette action'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Une erreur s\'est produite'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } on Exception {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Une erreur s\'est produite'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Ajouter au panier'),
                style: ElevatedButton.styleFrom(
                  primary: colorScheme.onSurface,
                  onPrimary: colorScheme.surface,
                ),
              ),
              FutureBuilder<bool>(
                future: _isInWishlistFuture,
                initialData: false,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    // ignore: prefer_function_declarations_over_variables
                    final actionFunc = () async {
                      if (data) {
                        await _wishlistService
                            .removeFromWishlist(widget.product);
                      } else {
                        await _wishlistService.addToWishlist(widget.product);
                      }
                    };
                    return WishlistButton(
                      background: colorScheme.surface,
                      foreground: colorScheme.onSurface,
                      isInWishlist: data,
                      onPressed: () async {
                        try {
                          await actionFunc();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                data
                                    ? 'Produit retiré de la liste de souhaits'
                                    : 'Produit ajouté à la liste de souhaits',
                              ),
                            ),
                          );
                        } on ApiHttpException catch (e) {
                          if (e.isAuthException) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Vous devez être authentifié pour réaliser cette action',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Une erreur s\'est produite'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Une erreur s\'est produite'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          fresh();
                        }
                      },
                    );
                  }
                  return WishlistButton(
                    background: colorScheme.surface,
                    foreground: colorScheme.onSurface,
                    isInWishlist: false,
                    onPressed: fresh,
                  );
                },
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.product.description,
              maxLines: null,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'Produits similaires',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: FutureBuilder<List<Product>>(
              future: getRelatedProducts(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Une erreur s\'est produite'),
                  );
                } else if (snapshot.hasData) {
                  return SizedBox(
                    height: size.height * 0.3,
                    child: ProductsHorizontalList(
                      onProductSelected: (Product product) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              product: product,
                              productService: _productService,
                              cartService: _cartService,
                              wishlistService: _wishlistService,
                            ),
                          ),
                        );
                      },
                      products: snapshot.data!,
                      productService: _productService,
                      cartService: _cartService,
                      wishlistService: _wishlistService,
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
