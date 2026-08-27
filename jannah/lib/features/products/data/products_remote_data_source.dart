import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jannah/features/products/data/item_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<Product>> fetchProducts();

  Future<Product> fetchProductById({required int productId});

  Future<List<Product>> fetchProductsByCategoryId({required int categoryId});

  Future<List<Product>> fetchProductsByName({required String productName});
}

class ApiProductsRemoteDataSource implements ProductsRemoteDataSource {
  ApiProductsRemoteDataSource({
    http.Client? client,
    String baseUrl = 'http://192.168.1.21:5241/api/products',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  Future<List<Product>> fetchProducts() async {
    final response = await _get(_baseUri);
    return _parseProductsList(response.body);
  }

  @override
  Future<Product> fetchProductById({required int productId}) async {
    final response = await _get(
      _baseUri.replace(path: '${_baseUri.path}/$productId'),
    );
    return _parseProduct(response.body);
  }

  @override
  Future<List<Product>> fetchProductsByCategoryId({
    required int categoryId,
  }) async {
    final response = await _get(
      _baseUri.replace(path: '${_baseUri.path}/category/$categoryId'),
    );
    return _parseProductsList(response.body);
  }

  @override
  Future<List<Product>> fetchProductsByName({
    required String productName,
  }) async {
    final response = await _get(
      _baseUri.replace(
        path: '${_baseUri.path}/search',
        queryParameters: {'name': productName},
      ),
    );
    return _parseProductsList(response.body);
  }

  Future<http.Response> _get(Uri uri) async {
    final response = await _client.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Products request failed (${response.statusCode}): ${response.body}',
      );
    }

    return response;
  }

  Product _parseProduct(String responseBody) {
    final decoded = jsonDecode(responseBody);
    final productJson = _unwrapObject(decoded);
    return Product.fromJson(productJson);
  }

  List<Product> _parseProductsList(String responseBody) {
    final decoded = jsonDecode(responseBody);
    final productsJson = _unwrapList(decoded);
    return productsJson
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }

  Map<String, dynamic> _unwrapObject(Object? decoded) {
    if (decoded is Map<String, dynamic>) {
      final nestedProduct =
          decoded['product'] ?? decoded['Product'] ?? decoded['data'];

      if (nestedProduct is Map<String, dynamic>) {
        return nestedProduct;
      }

      return decoded;
    }

    throw const FormatException('Expected a product object from the API.');
  }

  List<Map<String, dynamic>> _unwrapList(Object? decoded) {
    final Object? products = decoded is Map<String, dynamic>
        ? decoded['products'] ??
              decoded['Products'] ??
              decoded['items'] ??
              decoded['Items'] ??
              decoded['data']
        : decoded;

    if (products is List) {
      return products.whereType<Map<String, dynamic>>().toList(growable: false);
    }

    throw const FormatException('Expected a product list from the API.');
  }
}
