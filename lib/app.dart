import 'package:dresscode/models/product.dart';
import 'package:dresscode/models/image.dart' as img;
import 'package:dresscode/screens/login_screen.dart';
import 'package:dresscode/screens/product_screen.dart';
import 'package:dresscode/screens/register_screen.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/screens/home.dart';
import 'package:dresscode/screens/shop.dart';
import 'package:dresscode/screens/item_details.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DressCode',
      initialRoute: isLoggedIn ? Routes.home : Routes.login,
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
      routes: <String, Widget Function(BuildContext)>{
        Routes.home: (context) => const HomeScreen(),
        Routes.shop: (context) => const ShopScreen(),
        Routes.details: (context) => const ItemDetailsScreen(),
        Routes.login: (context) => const LoginScreen(),
        Routes.register: (context) => const RegisterScreen(),
      },
    );
  }
}

const prodScreen = ProductScreen(
  product: Product(
    name: 'Product',
    description:
    'As always any app will always need a form screen like login, signup, edit profile, request form and many more … This article aim to be a simple reference for the common form fields components Let’s see how to make a form with Jetpack Compose 🚀 We will cover all of the following points :',
    price: 2500,
    images: [
      img.Image(
        url:
        'https://miro.medium.com/max/1400/1*6L3DNpJTJy-dHjLOlhLPyQ.jpeg',
      ),
      img.Image(
        url:
        'https://www.section.io/engineering-education/authors/linus-muema/avatar_hu14290a859ab820b7d18e3bed053bd235_399298_180x0_resize_box_2.png',
      ),
      img.Image(
          url:
          'https://d3njjcbhbojbot.cloudfront.net/api/utilities/v1/imageproxy/http://coursera-university-assets.s3.amazonaws.com/5c/6a4547134c4268aa28c539f15c7ff7/EPFL-Logo-300-300.png?auto=format%2Ccompress&dpr=1&w=56px&h=56px&auto=format%2Ccompress&dpr=1&w=&h='),
      img.Image(
        url:
        'https://miro.medium.com/max/1400/1*wU442EfvB8z2qg6gvvgI4Q.gif',
      ),
      img.Image(
        url:
        'https://miro.medium.com/max/1400/1*6L3DNpJTJy-dHjLOlhLPyQ.jpeg',
      ),
    ],
  ),
);