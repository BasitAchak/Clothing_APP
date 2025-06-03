import '../models/product.dart';

class CartService {
  static final CartService instance = CartService._internal();

  CartService._internal();

  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
  }

  void clearCart() {
    _cartItems.clear();
  }
}