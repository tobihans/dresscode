import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/profile_information_widget.dart';
import 'package:dresscode/components/purchase_history_widget.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const OwnAppBar(),
        body: Column(
          children: const <Widget>[
            TabBar(
              tabs: [Tab(text: 'Mes informations'), Tab(text: 'Mes achats')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProfileInformationWidget(),
                  PurchaseHistoryWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
