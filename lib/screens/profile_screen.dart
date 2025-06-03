import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/login_screen.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final String email;
  final List<Order> orderHistory;

  const ProfileScreen({
    super.key,
    required this.email,
    required this.orderHistory,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String email;
  List<Product> wishlist = [
    Product(
      id: 'w1',
      name: 'Red Hoodie',
      description: 'Cozy red hoodie for casual wear',
      price: 39.99,
      imageUrl: 'assets/images/hoodie.png',
      stock: 8,
      category: 'Hoodies',
    ),
    Product(
      id: 'w2',
      name: 'White Sneakers',
      description: 'Stylish white sneakers for everyday use',
      price: 59.99,
      imageUrl: 'assets/images/sneakers.png',
      stock: 12,
      category: 'Footwear',
    ),
  ];

  @override
  void initState() {
    super.initState();
    email = widget.email;
    // Optionally, fetch name from UserProvider or backend here
    name = Provider.of<UserProvider>(context, listen: false).name ?? 'John Doe';
  }

  double get _profileCompletion {
    int completed = 0;
    if (name.isNotEmpty) completed++;
    if (email.isNotEmpty) completed++;
    return completed / 2;
  }

  void _logout(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).logout();
    Provider.of<CartProvider>(context, listen: false).clearCart();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              autofocus: true,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  emailController.text.trim().isEmpty) {
                // Simple validation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fields cannot be empty')),
                );
                return;
              }
              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'email': emailController.text.trim(),
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      setState(() {
        name = result['name']!;
        email = result['email']!;
        Provider.of<UserProvider>(context, listen: false).setUser(email, name);
      });
    }
  }

  Future<void> _changePassword() async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    String? passwordError;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    errorText: passwordError,
                  ),
                  onChanged: (value) {
                    setDialogState(() {
                      passwordError = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$')
                              .hasMatch(value)
                          ? null
                          : 'At least 6 chars, 1 uppercase, 1 number';
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: passwordError == null &&
                        newPasswordController.text.isNotEmpty
                    ? () => Navigator.pop(context, true)
                    : null,
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );

    if (result == true && mounted) {
      try {
        await AuthService.changePassword(
          email,
          oldPasswordController.text,
          newPasswordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ID: ${order.id}'),
              Text('Date: ${order.date.toString().split(' ')[0]}'),
              Text('Status: ${order.status}'),
              Text('Total: Rs. ${order.total.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...order.items.map(
                (item) => ListTile(
                  leading: Image.asset(
                    item.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.name),
                  subtitle: Text('Rs. ${item.price.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showWishlist() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wishlist'),
        content: SizedBox(
          height: 200,
          width: double.maxFinite,
          child: wishlist.isEmpty
              ? const Center(child: Text('Wishlist is empty'))
              : ListView.builder(
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    final product = wishlist[index];
                    return Dismissible(
                      key: Key(product.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        setState(() {
                          wishlist.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${product.name} removed from wishlist')),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              wishlist.removeAt(index);
                            });
                            Navigator.pop(context);
                            _showWishlist();
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage('assets/images/profile.jpg'),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 15),
              LinearProgressIndicator(
                value: _profileCompletion,
                backgroundColor: Colors.grey[300],
                color: Colors.teal,
                minHeight: 6,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Profile Completion: ${(_profileCompletion * 100).toInt()}%',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 25),
              Text('Name:', style: theme.textTheme.titleMedium),
              Text(name, style: theme.textTheme.titleLarge),
              const SizedBox(height: 15),
              Text('Email:', style: theme.textTheme.titleMedium),
              Text(email, style: theme.textTheme.titleLarge),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _changePassword,
                icon: const Icon(Icons.lock),
                label: const Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Order History'),
                      content: SizedBox(
                        height: 250,
                        width: double.maxFinite,
                        child: widget.orderHistory.isEmpty
                            ? const Center(child: Text('No past orders.'))
                            : ListView.builder(
                                itemCount: widget.orderHistory.length,
                                itemBuilder: (context, index) {
                                  final order = widget.orderHistory[index];
                                  return ListTile(
                                    title: Text('Order #${order.id}'),
                                    subtitle: Text(
                                        'Rs. ${order.total.toStringAsFixed(2)} - ${order.status}'),
                                    onTap: () => _showOrderDetails(order),
                                  );
                                },
                              ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('Order History'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _showWishlist,
                icon: const Icon(Icons.favorite_border),
                label: const Text('Wishlist'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: Colors.teal,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(150, 45),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
