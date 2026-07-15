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

  Future<void> checkout({required int cartId});

  Future<List<CartItem>> fetchCartItems({required int cartId});
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
  Future<void> checkout({required int cartId}) async {
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
