import '../models/product.dart';
import '../services/catalog_api_service.dart';

class CatalogRepository {
  final CatalogApiService _apiService;
  List<Product>? _cachedProducts;

  CatalogRepository(this._apiService);

  Future<List<Product>> getProducts() async {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    final rawData = await _apiService.fetchProductsRaw();
    final products = rawData
        .map(
          (json) => Product(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            price: json['price'],
            imageUrl: json['imageUrl'],
            category: json['category'],
          ),
        )
        .toList();

    _cachedProducts = products;
    return products;
  }
}
