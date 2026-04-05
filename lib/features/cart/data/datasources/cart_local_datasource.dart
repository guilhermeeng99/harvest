import 'package:harvest/features/cart/data/models/cart_item_model.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<void> saveCart(List<CartItemEntity> items);
  List<CartItemEntity> loadCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  const CartLocalDataSourceImpl(this._prefs);

  static const _key = 'cart_items';
  final SharedPreferences _prefs;

  @override
  Future<void> saveCart(List<CartItemEntity> items) async {
    if (items.isEmpty) {
      await _prefs.remove(_key);
      return;
    }
    await _prefs.setString(_key, CartItemModel.encodeList(items));
  }

  @override
  List<CartItemEntity> loadCart() {
    final jsonStr = _prefs.getString(_key);
    if (jsonStr == null) return [];
    try {
      return CartItemModel.decodeList(jsonStr);
    } on Object {
      return [];
    }
  }
}
