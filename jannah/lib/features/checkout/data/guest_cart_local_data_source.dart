import 'package:hive_flutter/hive_flutter.dart';
import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/data/cart_model.dart';
import 'package:jannah/features/checkout/data/checkout_remote_data_source.dart';

class GuestCartLocalDataSource implements CheckoutRemoteDataSource {
  static const guestUserId = 0;
  static const guestCartId = 0;

  final Box<dynamic> _box;

  GuestCartLocalDataSource({Box<dynamic>? box})
    : _box = box ?? Hive.box<dynamic>(AppPreferences.guestCartBoxName);

  @override
  Future<Cart?> fetchActiveCart({required int userId}) async {
    final items = _readItems();

    if (items.isEmpty) {
      return null;
    }

    final rawCart = _box.get(AppPreferences.guestCartKey);

    if (rawCart is Map<dynamic, dynamic>) {
      return Cart.fromJson(Map<String, dynamic>.from(rawCart));
    }

    return _createGuestCart();
  }

  @override
  Future<Cart> createCart({required int userId}) async {
    final existingCart = await fetchActiveCart(userId: userId);

    if (existingCart != null) {
      return existingCart;
    }

    final cart = _createGuestCart();
    await _box.put(AppPreferences.guestCartKey, cart.toJson());
    await _box.flush();
    return cart;
  }

  @override
  Future<void> deleteCart({required int cartId}) async {
    await _box.delete(AppPreferences.guestCartKey);
    await _box.put(AppPreferences.guestCartItemsKey, <Map<String, dynamic>>[]);
    await _box.flush();
  }

  @override
  Future<void> addItem({
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  }) async {
    final cart = await createCart(userId: userId);
    final items = _readItems();
    final index = items.indexWhere((item) => item.productId == productId);

    if (index == -1) {
      items.add(
        CartItem(
          cartItemId: await _nextCartItemId(),
          cartId: cart.cartId,
          productId: productId,
          quantity: quantity,
          price: price,
        ),
      );
    } else {
      final existingItem = items[index];
      items[index] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        price: price,
      );
    }

    await _saveItems(items);
  }

  @override
  Future<void> removeItem({required int userId, required int productId}) async {
    final items = _readItems();
    final index = items.indexWhere((item) => item.productId == productId);

    if (index == -1) {
      return;
    }

    final item = items[index];

    if (item.quantity > 1) {
      items[index] = item.copyWith(quantity: item.quantity - 1);
    } else {
      items.removeAt(index);
    }

    if (items.isEmpty) {
      await deleteCart(cartId: guestCartId);
      return;
    }

    await _saveItems(items);
  }

  @override
  Future<void> checkout({required int cartId}) {
    throw Exception('Please sign in to place your order.');
  }

  @override
  Future<List<CartItem>> fetchCartItems({required int cartId}) async {
    return _readItems();
  }

  Future<List<CartItem>> readItemsForSync() async {
    return _readItems();
  }

  Future<void> clear() {
    return deleteCart(cartId: guestCartId);
  }

  Cart _createGuestCart() {
    return Cart(
      cartId: guestCartId,
      userId: guestUserId,
      createdDate: DateTime.now(),
      isOrdered: false,
    );
  }

  Future<int> _nextCartItemId() async {
    final nextId =
        _box.get(AppPreferences.guestCartNextItemIdKey, defaultValue: 1) as int;
    await _box.put(AppPreferences.guestCartNextItemIdKey, nextId + 1);
    return nextId;
  }

  List<CartItem> _readItems() {
    final rawItems =
        _box.get(AppPreferences.guestCartItemsKey, defaultValue: <dynamic>[])
            as List<dynamic>;

    return rawItems.whereType<Map<dynamic, dynamic>>().map((rawItem) {
      return CartItem.fromJson(Map<String, dynamic>.from(rawItem));
    }).toList();
  }

  Future<void> _saveItems(List<CartItem> items) async {
    await _box.put(
      AppPreferences.guestCartItemsKey,
      items.map((item) => item.toJson()).toList(growable: false),
    );
    await _box.flush();
  }
}
