import 'package:dresscode/api/services/cart_service.dart';
import 'package:dresscode/api/services/product_service.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/image_widget_gallery.dart';
import 'package:dresscode/models/product.dart';
import 'package:flutter/material.dart';

/// TODO : Connect actions
class ProductScreen extends StatefulWidget {
  final Product product;
  final CartService cartService;

  const ProductScreen({
    Key? key,
    required this.product,
    required this.cartService
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductService _productService;
  late CartService _cartService;
  bool _isLoading = false;


  Future<void> addToCart(Product product) async {
    await _cartService.addProductToCart(widget.product);
  }

  @override
  void initState() {
    _cartService = widget.cartService;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productImages =
        widget.product.images?.map((img) => img.url).toList(growable: false) ??
            [];
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
            child: Container(),
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
              ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.bookmark_border),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: const BorderSide(
                    width: 2.0,
                    color: Colors.black,
                  ),
                  primary: colorScheme.surface,
                  onPrimary: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
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
          )
        ],
      ),
    );
  }
}
