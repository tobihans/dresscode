import 'package:dresscode/models/product.dart';

extension ProductExtensions on Product {
  List<String> get imageUrls =>
      images?.map((e) => e.url).toList(growable: false) ?? [];
}
