import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dresscode/components/notifications_widget.dart';

class OwnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OwnAppBar({Key? key}) : super(key: key);

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
