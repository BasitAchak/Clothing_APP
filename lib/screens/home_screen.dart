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
      id: '2',
      name: 'Denim Jeans',
      description: 'Stylish blue jeans',
      price: 49.99,
      imageUrl: 'assets/images/jeans.png',
      stock: 15,
      category: 'Jeans',
    ),
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
      id: '4',
      name: 'Graphic T-Shirt',
      description: 'Cool graphic tee',
      price: 19.99,
      imageUrl: 'assets/images/tshirt.png',
      stock: 30,
      category: 'T-Shirts',
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
                      builder: (context) => CartScreen(userEmail: widget.userEmail),
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
                      style: const TextStyle(color: Color.fromARGB(255, 149, 28, 151), fontSize: 12),
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
            categories: ['All', 'Shirts', 'Jeans', 'Jackets', 'T-Shirts'],
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
                        builder: (context) => ProductDetailScreen(product: product),
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
    return _products.where((product) => product.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? _buildHomeContent()
          : ProfileScreen(
              email: widget.userEmail,
              orderHistory: [], // Pass real order history if available
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
