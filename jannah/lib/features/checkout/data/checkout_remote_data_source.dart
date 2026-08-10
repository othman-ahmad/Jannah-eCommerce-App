// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/data/cart_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<Cart?> fetchActiveCart({required int userId});

  Future<Cart> createCart({required int userId});

  Future<void> deleteCart({required int cartId});

  Future<void> addItem({
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  });

  Future<void> removeItem({required int userId, required int productId});

  Future<void> checkout({
    required int cartId,
    required int addressId,
    required String paymentMethod,
  });

  Future<List<CartItem>> fetchCartItems({required int cartId});
}

class ApiCheckoutRemoteDataSource implements CheckoutRemoteDataSource {
  ApiCheckoutRemoteDataSource({
    http.Client? client,
    String baseUrl = 'http://192.168.1.75:5241/api',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  Future<Cart?> fetchActiveCart({required int userId}) async {
    final response = await _client
        .get(_uriFor('cart/active/$userId'), headers: _jsonHeaders)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 404 || response.statusCode == 204) {
      return null;
    }

    _throwIfRequestFailed(response, 'Cart request failed');
    final decoded = _decodeJson(response.body);
    if (decoded == null) {
      return null;
    }

    return Cart.fromJson(_unwrapObject(decoded, 'cart'));
  }

  @override
  Future<Cart> createCart({required int userId}) async {
    final activeCart = await fetchActiveCart(userId: userId);
    if (activeCart != null) {
      return activeCart;
    }

    throw Exception('No active cart found. Add an item to create a cart.');
  }

  @override
  Future<void> deleteCart({required int cartId}) {
    throw UnsupportedError(
      'Deleting a whole cart is not supported by the API.',
    );
  }

  @override
  Future<void> addItem({
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  }) async {
    final response = await _client
        .post(
          _uriFor('cart/items'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'userId': userId,
            'productId': productId,
            'quantity': quantity,
          }),
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Add cart item request failed');
  }

  @override
  Future<void> removeItem({required int userId, required int productId}) async {
    final response = await _client
        .delete(
          _uriFor('cart/items'),
          headers: _jsonHeaders,
          body: jsonEncode({'userId': userId, 'productId': productId}),
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Remove cart item request failed');
  }

  @override
  Future<void> checkout({
    required int cartId,
    required int addressId,
    required String paymentMethod,
  }) async {
    final response = await _client
        .post(
          _uriFor('cart/checkout/$cartId'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'addressId': addressId,
            'paymentMethod': paymentMethod,
          }),
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Checkout request failed');
  }

  @override
  Future<List<CartItem>> fetchCartItems({required int cartId}) async {
    final response = await _client
        .get(_uriFor('cart/$cartId/items'), headers: _jsonHeaders)
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Cart items request failed');

    return _unwrapList(
      _decodeJson(response.body),
      'items',
    ).map(CartItem.fromJson).toList(growable: false);
  }

  Uri _uriFor(String pathSegment) {
    final path = _baseUri.path.endsWith('/')
        ? '${_baseUri.path}$pathSegment'
        : '${_baseUri.path}/$pathSegment';

    return _baseUri.replace(path: path);
  }

  Object? _decodeJson(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    return jsonDecode(responseBody);
  }

  Map<String, dynamic> _unwrapObject(Object? decoded, String objectName) {
    if (decoded is Map) {
      final json = Map<String, dynamic>.from(decoded);
      for (final key in [
        objectName,
        _capitalize(objectName),
        'data',
        'Data',
        'result',
        'Result',
      ]) {
        final value = json[key];
        if (value is Map) {
          return Map<String, dynamic>.from(value);
        }
      }

      return json;
    }

    throw FormatException('Expected a $objectName object from the API.');
  }

  List<Map<String, dynamic>> _unwrapList(Object? decoded, String listName) {
    final Object? list = decoded is Map
        ? decoded[listName] ??
              decoded[_capitalize(listName)] ??
              decoded['cartItems'] ??
              decoded['CartItems'] ??
              decoded['data'] ??
              decoded['Data'] ??
              decoded['result'] ??
              decoded['Result']
        : decoded;

    if (list is List) {
      return list
          .whereType<Map>()
          .map((itemJson) => Map<String, dynamic>.from(itemJson))
          .toList(growable: false);
    }

    throw FormatException('Expected a $listName list from the API.');
  }

  void _throwIfRequestFailed(http.Response response, String fallbackMessage) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw Exception(
      _extractErrorMessage(response.body) ??
          '$fallbackMessage (${response.statusCode}).',
    );
  }

  String? _extractErrorMessage(String responseBody) {
    try {
      final decoded = _decodeJson(responseBody);
      if (decoded is! Map) {
        return responseBody.trim().isEmpty ? null : responseBody;
      }

      final json = Map<String, dynamic>.from(decoded);
      for (final key in const [
        'message',
        'Message',
        'error',
        'Error',
        'title',
      ]) {
        final value = json[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }

      final errors = json['errors'];
      if (errors is Map && errors.isNotEmpty) {
        return errors.values
            .expand((value) => value is List ? value : [value])
            .map((value) => value.toString())
            .join('\n');
      }
    } catch (_) {
      return responseBody.trim().isEmpty ? null : responseBody;
    }

    return null;
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static const _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}

class InMemoryCheckoutRemoteDataSource implements CheckoutRemoteDataSource {
  final List<Cart> _carts = [];
  final List<CartItem> _cartItems = [];
  int _nextCartId = 1;
  int _nextCartItemId = 1;

  @override
  Future<Cart?> fetchActiveCart({required int userId}) async {
    final activeCarts = _carts.where(
      (cart) => cart.userId == userId && !cart.isOrdered,
    );

    if (activeCarts.isEmpty) {
      return null;
    }

    return Cart.fromJson(activeCarts.first.toJson());
  }

  @override
  Future<Cart> createCart({required int userId}) async {
    final existingCart = await fetchActiveCart(userId: userId);

    if (existingCart != null) {
      return existingCart;
    }

    final cart = Cart(
      cartId: _nextCartId++,
      userId: userId,
      createdDate: DateTime.now(),
      isOrdered: false,
    );

    _carts.add(cart);
    _printDatabaseState('CREATE CART');
    return Cart.fromJson(cart.toJson());
  }

  @override
  Future<void> deleteCart({required int cartId}) async {
    _cartItems.removeWhere((item) => item.cartId == cartId);
    _carts.removeWhere((cart) => cart.cartId == cartId);
    _printDatabaseState('DELETE CART');
  }

  @override
  Future<void> addItem({
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  }) async {
    final cart = await createCart(userId: userId);
    final index = _cartItems.indexWhere(
      (item) => item.cartId == cart.cartId && item.productId == productId,
    );

    if (index == -1) {
      _cartItems.add(
        CartItem(
          cartItemId: _nextCartItemId++,
          cartId: cart.cartId,
          productId: productId,
          quantity: quantity,
          price: price,
        ),
      );
      _printDatabaseState('ADD ITEM');
      return;
    }

    final existingItem = _cartItems[index];
    _cartItems[index] = existingItem.copyWith(
      quantity: existingItem.quantity + quantity,
      price: price,
    );
    _printDatabaseState('UPDATE ITEM QUANTITY');
  }

  @override
  Future<void> removeItem({required int userId, required int productId}) async {
    final cart = await fetchActiveCart(userId: userId);

    if (cart == null) {
      return;
    }

    final index = _cartItems.indexWhere(
      (item) => item.cartId == cart.cartId && item.productId == productId,
    );

    if (index == -1) {
      return;
    }

    final item = _cartItems[index];

    if (item.quantity > 1) {
      _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
      _printDatabaseState('DECREASE ITEM QUANTITY');
    } else {
      _cartItems.removeAt(index);
      _printDatabaseState('REMOVE ITEM');
    }

    final remainingItems = _cartItems.where(
      (item) => item.cartId == cart.cartId,
    );

    if (remainingItems.isEmpty) {
      await deleteCart(cartId: cart.cartId);
    }
  }

  @override
  Future<void> checkout({
    required int cartId,
    required int addressId,
    required String paymentMethod,
  }) async {
    final index = _carts.indexWhere((cart) => cart.cartId == cartId);

    if (index == -1) {
      throw Exception('Cart not found');
    }

    _carts[index] = _carts[index].copyWith(isOrdered: true);
    _printDatabaseState('CHECKOUT');
  }

  @override
  Future<List<CartItem>> fetchCartItems({required int cartId}) async {
    return _cartItems
        .where((item) => item.cartId == cartId)
        .map((item) => CartItem.fromJson(item.toJson()))
        .toList(growable: false);
  }

  void _printDatabaseState(String operation) {
    print('\n');
    print('==================== MOCK DATABASE ====================');
    print('Operation: $operation');
    print('');

    _printCartsTable();
    print('');
    _printCartItemsTable();

    print('=======================================================\n');
  }

  void _printCartsTable() {
    print('CARTS TABLE');

    if (_carts.isEmpty) {
      print('(empty)');
      return;
    }

    print(
      '--------------------------------------------------------------------------------',
    );
    print('| CartId | UserId | Created Date              | IsOrdered |');
    print(
      '--------------------------------------------------------------------------------',
    );

    for (final cart in _carts) {
      print(
        '| ${cart.cartId.toString().padRight(6)} '
        '| ${cart.userId.toString().padRight(6)} '
        '| ${cart.createdDate.toString().padRight(25)} '
        '| ${cart.isOrdered.toString().padRight(9)} |',
      );
    }

    print(
      '--------------------------------------------------------------------------------',
    );
  }

  void _printCartItemsTable() {
    print('CART ITEMS TABLE');

    if (_cartItems.isEmpty) {
      print('(empty)');
      return;
    }

    print(
      '---------------------------------------------------------------------------------------------',
    );
    print('| ItemId | CartId | ProductId | Quantity | Price      |');
    print(
      '---------------------------------------------------------------------------------------------',
    );

    for (final item in _cartItems) {
      print(
        '| ${item.cartItemId.toString().padRight(6)} '
        '| ${item.cartId.toString().padRight(6)} '
        '| ${item.productId.toString().padRight(9)} '
        '| ${item.quantity.toString().padRight(8)} '
        '| ${item.price.toStringAsFixed(2).padRight(10)} |',
      );
    }

    print(
      '---------------------------------------------------------------------------------------------',
    );
  }
}
