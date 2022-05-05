import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dresscode/components/notifications_widget.dart';
import 'package:dresscode/components/search_page.dart';

class OwnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OwnAppBar({Key? key}) : super(key: key);

  //TODO: THIS LIST HAVE TO BE PASSED DYNAMICALLY BASED ON PAGE THAT USER SEARCH BAR
  static final List<dynamic> _journalsForSearch = [
    {'code':'#0', 'name':'Coco', 'description':'Coco desc', 'price':150, 'image':[]},
    {'code':'#1', 'name':'Polo', 'description':'Polo desc', 'price':200, 'image':[]},
    {'code':'#2', 'name':'Coco', 'description':'Coco desc', 'price':350, 'image':[]},
    {'code':'#3', 'name':'Polo', 'description':'Polo desc', 'price':400, 'image':[]},
    {'code':'#4', 'name':'Coco', 'description':'Coco desc', 'price':550, 'image':[]},
    {'code':'#5', 'name':'Polo', 'description':'Polo desc', 'price':600, 'image':[]},
    {'code':'#6', 'name':'Coco', 'description':'Coco desc', 'price':750, 'image':[]},
    {'code':'#7', 'name':'Polo', 'description':'Polo desc', 'price':800, 'image':[]}];

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      elevation: 0.375,
      backgroundColor: colorScheme.background,
      leading: Transform.translate(
        offset: const Offset(0, 10),
        child: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(
            Icons.menu,
            color: colorScheme.onBackground,
          ),
        ),
      ),
      actions: <Widget>[
        // Research Button Icon
        Transform.translate(
          offset: const Offset(0, 10),
          child: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return SearchPage(journals: _journalsForSearch);
                    }
                )
            ),
            icon: Icon(
              Icons.search,
              color: colorScheme.onBackground,
            ),
          ),
        ),

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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.notifications_none_outlined,
              color: colorScheme.onBackground,
            ),
          ),
        )
      ],
    );
  }
}
