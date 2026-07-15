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
    print('othman : Fetching active cart for userId: $userId');
    final activeCarts = _carts.where(
      (cart) => cart.userId == userId && !cart.isOrdered,
    );

    if (activeCarts.isEmpty) {
      return null;
    }
    print(
      'othman : Active cart found for userId: $userId, cartId: ${activeCarts.first.cartId}',
    );
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
    print(
      'othman : Created new cart for userId: $userId, cartId: ${cart.cartId}',
    );
    return Cart.fromJson(cart.toJson());
  }

  @override
  Future<void> deleteCart({required int cartId}) async {
    _cartItems.removeWhere((item) => item.cartId == cartId);
    _carts.removeWhere((cart) => cart.cartId == cartId);
    print('othman : Deleted cart with cartId: $cartId');
  }

  @override
  Future<void> addItem({
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  }) async {
    print(
      'othman : Adding item to cart for userId: $userId, productId: $productId, quantity: $quantity, price: $price',
    );
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
      return;
    }

    final existingItem = _cartItems[index];
    _cartItems[index] = existingItem.copyWith(
      quantity: existingItem.quantity + quantity,
      price: price,
    );
  }

  @override
  Future<void> removeItem({required int userId, required int productId}) async {
    print(
      'othman : Removing item from cart for userId: $userId, productId: $productId',
    );
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
    } else {
      _cartItems.removeAt(index);
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
    print('othman : Checking out cart with cartId: $cartId');
    final index = _carts.indexWhere((cart) => cart.cartId == cartId);

    if (index == -1) {
      throw Exception('Cart not found');
    }

    _carts[index] = _carts[index].copyWith(isOrdered: true);
  }

  @override
  Future<List<CartItem>> fetchCartItems({required int cartId}) async {
    print('othman : Fetching cart items for cartId: $cartId');
    return _cartItems
        .where((item) => item.cartId == cartId)
        .map((item) => CartItem.fromJson(item.toJson()))
        .toList(growable: false);
  }
}
