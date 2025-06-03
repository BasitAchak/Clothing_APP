import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'theme.dart';
import 'services/storage_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
   
  Future<Widget> _getInitialScreen() async {
    final seenOnboarding = await StorageService.hasSeenOnboarding();
    if (!seenOnboarding) {
      return const OnboardingScreen();
    }

    final userEmail = await StorageService.getUserSession();
    if (userEmail != null) {
      return HomeScreen(userEmail: userEmail);
    }

    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clothing Store',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data ?? const LoginScreen();
        },
      ),
      routes: {
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final email = args is String ? args : '';
          return HomeScreen(userEmail: email);
        },
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
