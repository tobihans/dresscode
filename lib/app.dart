import 'package:dresscode/screens/checkout_screen.dart';
import 'package:dresscode/screens/forgot_password_screen.dart';
import 'package:dresscode/screens/password_reset_screen.dart';
import 'package:dresscode/screens/search_screen.dart';
import 'package:dresscode/screens/home.dart';
import 'package:dresscode/screens/login_screen.dart';
import 'package:dresscode/screens/profile_screen.dart';
import 'package:dresscode/screens/register_screen.dart';
import 'package:dresscode/screens/shop.dart';
import 'package:dresscode/screens/wishlist_screen.dart';
import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dresscode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.notoSansTextTheme(
          ThemeData.from(colorScheme: lightColorScheme).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.notoSansTextTheme(
          ThemeData.from(colorScheme: darkColorScheme).textTheme,
        ),
      ),
      themeMode: ThemeMode.system,
      routes: {
        Routes.home: (context) => const HomeScreen(),
        Routes.shop: (context) => const ShopScreen(),
        Routes.login: (context) => const LoginScreen(),
        Routes.register: (context) => const RegisterScreen(),
        Routes.wishlist: (context) => const WishlistScreen(),
        Routes.profile: (context) => const ProfileScreen(),
        Routes.search: (context) => const SearchScreen(),
        Routes.checkout: (context) => const CheckoutScreen(),
        Routes.forgotPassword: (context) => const ForgotPasswordScreen(),
        Routes.passwordReset: (context) => const PasswordResetScreen(),
      },
    );
  }
}
