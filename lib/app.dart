import 'package:flutter/material.dart';
import './utils/colors.dart';
import './screens/home.dart';
import './screens/shop.dart';
import './screens/item_details.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DressCode',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      routes: {
        '/': (context) => const HomeScreen(title: ''),
        '/shop': (context) => const ShopScreen(),
        'details': (context) => const ItemDetailsScreen(),
      },
    );
  }
}
