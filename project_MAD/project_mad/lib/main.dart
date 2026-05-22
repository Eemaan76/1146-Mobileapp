import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/property_provider.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/contact_us_screen.dart';
import 'screens/property/add_property_screen.dart';
import 'screens/property/listings_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/splash/splash_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: RentalApp(),
    ),
  );
}

class RentalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/edit-profile': (context) => EditProfileScreen(),
        '/contact-us': (context) => ContactUsScreen(),
        '/add-property': (context) => AddPropertyScreen(),
        '/listings': (context) => ListingsScreen(),
        '/search': (context) => SearchScreen(),
        '/map': (context) => MapScreen(),
      },
    );
  }
}
