import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/order.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];
  final Map<String, int> _quantities = {};
  final List<Order> _orderHistory = [];

  List<Product> get items => _items;
  List<Order> get orderHistory => _orderHistory;

  int get itemCount =>
      _items.fold(0, (sum, item) => sum + (_quantities[item.id] ?? 1));

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * (_quantities[item.id] ?? 1);
    }
    return total;
  }

  int getQuantity(Product product) => _quantities[product.id] ?? 1;

  void addToCart(Product product) {
    if (!_items.contains(product)) {
      _items.add(product);
      _quantities[product.id] = 1;
    } else {
      _quantities[product.id] = (_quantities[product.id] ?? 1) + 1;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    _quantities.remove(product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
    } else {
      _quantities[product.id] = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _quantities.clear();
    notifyListeners();
  }

  void checkout(String userEmail) {
    if (_items.isNotEmpty) {
      final order = Order(
        id: 'order${DateTime.now().millisecondsSinceEpoch}',
        items: List.from(_items),
        total: totalPrice,
        date: DateTime.now(),
        status: 'Pending',
      );
      _orderHistory.add(order);
      clearCart();
      notifyListeners();
    }
  }
}
