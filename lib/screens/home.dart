import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.375,
        actions: <Widget>[
          // It's too complicated to get a dot on top of this when there are notifications
          // As a workaround, we'll change the icon and its color just
          Transform.translate(
              offset: const Offset(0, 10),
              child: IconButton(
                  onPressed: () {},
                  color: Color(CustomColors.raw['primaryText']!),
                  icon: const Icon(Icons.notifications_none_outlined)))
        ],
      ),
      body: const Scaffold(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Panier',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
