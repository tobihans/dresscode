import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/components/notifications_widget.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/utils/colors.dart';

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
              onPressed: () {
                showFlexibleBottomSheet(
                  minHeight: 0,
                  initHeight: 0.5,
                  maxHeight: 1,
                  anchors: [0, 0.5, 1],
                  context: context,
                  builder: (BuildContext context,
                      ScrollController scrollController,
                      double bottomSheetOffset) {
                    return const SafeArea(
                      child: Material(
                        child: NotificationsWidget(),
                        elevation: 0.4,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    );
                  },
                );
              },
              color: Color(CustomColors.raw['primaryText']!),
              icon: const Icon(Icons.notifications_none_outlined),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: const Scaffold(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Panier',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
