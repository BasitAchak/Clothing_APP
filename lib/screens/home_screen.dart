import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_widget.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  int _selectedIndex = 0;

  final List<Product> _products = [
    // Shirts
    Product(
      id: '1',
      name: 'Casual Shirt',
      description: 'Comfortable cotton shirt',
      price: 29.99,
      imageUrl: 'assets/images/shirt.png',
      stock: 20,
      category: 'Shirts',
    ),
    Product(
      id: '14',
      name: 'Formal Shirt',
      description: 'Business formal shirt',
      price: 34.99,
      imageUrl: 'assets/images/shirt1.png',
      stock: 17,
      category: 'Shirts',
    ),
    Product(
      id: '15',
      name: 'Linen Shirt',
      description: 'Breathable linen shirt',
      price: 38.99,
      imageUrl: 'assets/images/shirt2.png',
      stock: 10,
      category: 'Shirts',
    ),

    // Jeans
    Product(
      id: '2',
      name: 'Denim Jeans',
      description: 'Stylish blue jeans',
      price: 49.99,
      imageUrl: 'assets/images/jeans.png',
      stock: 15,
      category: 'Jeans',
    ),
    Product(
      id: '12',
      name: 'Black Jeans',
      description: 'Slim fit black jeans',
      price: 54.99,
      imageUrl: 'assets/images/jeans1.png',
      stock: 13,
      category: 'Jeans',
    ),
    Product(
      id: '13',
      name: 'Ripped Jeans',
      description: 'Distressed ripped jeans',
      price: 59.99,
      imageUrl: 'assets/images/jeans2.png',
      stock: 10,
      category: 'Jeans',
    ),

    // Jackets
    Product(
      id: '3',
      name: 'Leather Jacket',
      description: 'Premium leather jacket',
      price: 99.99,
      imageUrl: 'assets/images/jacket.png',
      stock: 10,
      category: 'Jackets',
    ),
    Product(
      id: '9',
      name: 'Bomber Jacket',
      description: 'Classic bomber jacket',
      price: 89.99,
      imageUrl: 'assets/images/jacket1.png',
      stock: 8,
      category: 'Jackets',
    ),
    Product(
      id: '10',
      name: 'Puffer Jacket',
      description: 'Insulated puffer jacket',
      price: 109.99,
      imageUrl: 'assets/images/jacket2.png',
      stock: 9,
      category: 'Jackets',
    ),
    Product(
      id: '11',
      name: 'Rain Jacket',
      description: 'Waterproof rain jacket',
      price: 69.99,
      imageUrl: 'assets/images/jacket3.png',
      stock: 11,
      category: 'Jackets',
    ),

    // T-Shirts
    Product(
      id: '4',
      name: 'Graphic T-Shirt',
      description: 'Cool graphic tee',
      price: 19.99,
      imageUrl: 'assets/images/tshirt.png',
      stock: 30,
      category: 'T-Shirts',
    ),
    Product(
      id: '16',
      name: 'Plain T-Shirt',
      description: 'Basic plain tee',
      price: 14.99,
      imageUrl: 'assets/images/tshirt1.png',
      stock: 25,
      category: 'T-Shirts',
    ),
    Product(
      id: '17',
      name: 'Striped T-Shirt',
      description: 'T-shirt with stripes',
      price: 18.99,
      imageUrl: 'assets/images/tshirt2.png',
      stock: 20,
      category: 'T-Shirts',
    ),
    Product(
      id: '18',
      name: 'V-Neck T-Shirt',
      description: 'V-neck cotton t-shirt',
      price: 16.99,
      imageUrl: 'assets/images/tshirt3.png',
      stock: 22,
      category: 'T-Shirts',
    ),

    // Hoodies
    Product(
      id: '5',
      name: 'Classic Hoodie',
      description: 'Warm and cozy hoodie',
      price: 39.99,
      imageUrl: 'assets/images/hoodie.png',
      stock: 18,
      category: 'Hoodies',
    ),
    Product(
      id: '6',
      name: 'Zip Hoodie',
      description: 'Zipper hoodie with pockets',
      price: 42.99,
      imageUrl: 'assets/images/hoodie2.png',
      stock: 12,
      category: 'Hoodies',
    ),
    Product(
      id: '7',
      name: 'Oversized Hoodie',
      description: 'Trendy oversized hoodie',
      price: 45.99,
      imageUrl: 'assets/images/hoodie3.png',
      stock: 14,
      category: 'Hoodies',
    ),
    Product(
      id: '8',
      name: 'Slim Fit Hoodie',
      description: 'Slim fit stylish hoodie',
      price: 41.99,
      imageUrl: 'assets/images/hoodie4.png',
      stock: 16,
      category: 'Hoodies',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothing Store'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CartScreen(userEmail: widget.userEmail),
                    ),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 149, 28, 151),
                          fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSearch: (query) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Searching for: $query')),
              );
            },
          ),
          CategoryFilterWidget(
            categories: [
              'All',
              'Shirts',
              'Jeans',
              'Jackets',
              'T-Shirts',
              'Hoodies',
            ],
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLargeScreen ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (ctx, i) {
                final product = _filteredProducts[i];
                return ProductWidget(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? _buildHomeContent()
          : ProfileScreen(
              email: widget.userEmail,
              orderHistory: [],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
