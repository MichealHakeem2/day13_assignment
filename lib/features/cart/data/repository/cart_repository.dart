import 'package:flutter/foundation.dart';
import 'package:shopping_app/features/cart/data/local/cart_local_data_source.dart';
import 'package:shopping_app/features/cart/data/models/cart_item_model.dart';
import 'package:shopping_app/features/cart/data/remote/cart_remote_data_source.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';

class CartRepository {
  static final CartRepository instance = CartRepository._internal();
  factory CartRepository() => instance;
  CartRepository._internal() {
    refreshCartCount();
  }

  final CartRemoteDataSource remoteDataSource = CartRemoteDataSource();
  final CartLocalDataSource localDataSource = CartLocalDataSource();

  final ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(0);

  Future<void> refreshCartCount() async {
    try {
      final items = await localDataSource.getCart();
      int count = 0;
      for (var item in items) {
        count += item.quantity;
      }
      cartCountNotifier.value = count;
    } catch (_) {}
  }

  Future<List<CartItemModel>> getCart() async {
    try {
      final remoteItems = await remoteDataSource.getCart();
      if (remoteItems.isNotEmpty) {
        await localDataSource.cacheCartItems(remoteItems);
        await refreshCartCount();
        return remoteItems;
      }
    } catch (_) {}

    final localItems = await localDataSource.getCart();
    await refreshCartCount();
    return localItems;
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final item = CartItemModel(
      productId: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      quantity: quantity,
    );

    await localDataSource.addToCart(item);
    await refreshCartCount();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await localDataSource.updateQuantity(productId, quantity);
    await refreshCartCount();
  }

  Future<void> deleteFromCart(int productId) async {
    await localDataSource.deleteFromCart(productId);
    await refreshCartCount();
  }

  Future<void> clearCart() async {
    await localDataSource.clearCart();
    await refreshCartCount();
  }
}

