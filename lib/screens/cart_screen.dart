import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final String userEmail;

  const CartScreen({super.key, required this.userEmail});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  String? _promoError;
  List<Product> savedForLater = [];

  void applyPromoCode() {
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _promoError = 'Enter a promo code';
      });
    } else if (code != 'SAVE10') {
      setState(() {
        _promoError = 'Invalid promo code';
      });
    } else {
      setState(() {
        _promoError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo code applied!')),
      );
    }
  }

  void saveForLater(Product product, CartProvider cartProvider) {
    setState(() {
      savedForLater.add(product);
      cartProvider.removeFromCart(product);
    });
  }

  void moveToCart(Product product, CartProvider cartProvider) {
    setState(() {
      cartProvider.addToCart(product);
      savedForLater.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cartItems.isEmpty && savedForLater.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) {
                      final product = cartItems[i];
                      final quantity = cartProvider.getQuantity(product);
                      return Dismissible(
                        key: Key(product.id),
                        onDismissed: (direction) {
                          cartProvider.removeFromCart(product);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Image.asset(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                            title: Text(product.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rs. ${product.price.toStringAsFixed(2)}'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (quantity > 1) {
                                          cartProvider.updateQuantity(product, quantity - 1);
                                        }
                                      },
                                    ),
                                    Text('$quantity'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        if (quantity < product.stock) {
                                          cartProvider.updateQuantity(product, quantity + 1);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () => saveForLater(product, cartProvider),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (savedForLater.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Saved for Later', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: savedForLater.length,
                            itemBuilder: (ctx, i) {
                              final product = savedForLater[i];
                              return ListTile(
                                leading: Image.asset(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                                title: Text(product.name),
                                subtitle: Text('Rs. ${product.price.toStringAsFixed(2)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  onPressed: () => moveToCart(product, cartProvider),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.teal[50],
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _promoController,
                          decoration: InputDecoration(
                            labelText: 'Promo Code',
                            errorText: _promoError,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: applyPromoCode,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: Rs. ${cartProvider.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirm Checkout'),
                                    content: Text(
                                      'Total: Rs. ${cartProvider.totalPrice.toStringAsFixed(2)}\nProceed?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          cartProvider.checkout(widget.userEmail);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Order placed successfully!')),
                                          );
                                        },
                                        child: const Text('Confirm'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Checkout'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }
}
