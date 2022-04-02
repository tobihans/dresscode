import 'package:dresscode/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/home_hero.dart';

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
        children: const <Widget>[
          HomeHero(),
        ],
      ),
    );
  }
}
