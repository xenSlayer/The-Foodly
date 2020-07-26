import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodly/models/cartItem.dart';
import 'package:foodly/models/product.dart';
import 'package:foodly/services/db_services.dart';
import 'package:foodly/utilities/utils.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartList = [];

  List<CartItem> get cartList => _cartList;

  void setCartList(List<CartItem> carts) {
    _cartList = carts;
    print("Cart List Updated - ${carts.length}");
  }

  void addToCart(Product product, String userId, {int quantity = 1}) {
    if (userId == null) {
      Utils.showToast("Login To Add & View Cart");
    } else {
      CartItem cartItem = CartItem(
          id: null,
          name: product.name,
          imageUrl: product.imageUrl,
          price: product.salePrice,
          quantity: quantity,
          productId: product.id,
          userId: userId);
      cartItemDb.createItem(cartItem);
      Utils.showToast("${product.name} is added to cart");
    }
    notifyListeners();
  }

  void deleteCartAt(int index, int price, String id) {
    cartItemDb.removeItem(id);
    Utils.showToast("Removed from cart");
    notifyListeners();
  }

  void incrementCart(CartItem cartItem) {
    CartItem upcartItem = CartItem(
        id: cartItem.id,
        name: cartItem.name,
        imageUrl: cartItem.imageUrl,
        price: cartItem.price,
        quantity: cartItem.quantity + 1,
        productId: cartItem.productId,
        userId: cartItem.userId);
    cartItemDb.updateItem(upcartItem);
    notifyListeners();
  }

  void decrementCart(CartItem cartItem) {
    int newQuantity = cartItem.quantity - 1;
    if (newQuantity == 0) {
      cartItemDb.removeItem(cartItem.id);
    } else {
      CartItem upcartItem = CartItem(
          id: cartItem.id,
          name: cartItem.name,
          imageUrl: cartItem.imageUrl,
          price: cartItem.price,
          quantity: cartItem.quantity - 1,
          productId: cartItem.productId,
          userId: cartItem.userId);
      cartItemDb.updateItem(upcartItem);
    }
    notifyListeners();
  }

  void deleteCart() {
    for (int i = 0; i < _cartList.length; i++) {
      cartItemDb.removeItem(_cartList[i].id);
    }
    notifyListeners();
  }
}
