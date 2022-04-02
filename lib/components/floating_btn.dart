import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dresscode/components/cart_widget.dart';
import 'package:flutter/material.dart';

class FloatingBtn extends StatelessWidget {
  const FloatingBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showFlexibleBottomSheet(
          minHeight: 0,
          initHeight: 0.5,
          maxHeight: 0.75,
          context: context,
          builder: (BuildContext context, ScrollController scrollController,
              double bottomSheetOffset) {
            return SafeArea(
              child: Material(
                child: CartWidget(
                  scrollController: scrollController,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            );
          },
        );
      },
      tooltip: 'Panier',
      child: const Icon(Icons.shopping_cart),
    );
  }
}
