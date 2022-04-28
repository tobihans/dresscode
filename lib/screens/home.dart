import 'package:dresscode/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/home_hero.dart';
import 'package:dresscode/components/category.dart';
import 'package:dresscode/components/top_model.dart';
import 'package:dresscode/components/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const HomeHero(
                text: "Collection d'été 2021",
              )),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const Text('Categories')),
          SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(12, (i) => i)
                    .map((e) => Category(
                        name: "Categorie $e",
                        url:
                            "https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=10$e"))
                    .toList(),
              )),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const Text('Les top modèles')),
          SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(9, (i) => i)
                    .map((e) => TopModel(
                        name: "Jan$e",
                        url:
                            "https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=10$e"))
                    .toList(),
              )),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const Text('Les top modèles')),
          SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(9, (i) => i)
                    .map((e) => const ProductCard())
                    .toList(),
              ))
        ],
      ),
    );
  }
}
