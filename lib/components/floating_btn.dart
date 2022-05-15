import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dresscode/api/services/auth_service.dart';
import 'package:dresscode/components/cart_widget.dart';
import 'package:flutter/material.dart';

/// Floating action button with the cart icon and a badge
/// Do not show if the user is not authenticated
class FloatingBtn extends StatelessWidget {
  const FloatingBtn({Key? key}) : super(key: key);

  Future<bool> _isAuthenticated() async {
    return (await AuthService.getUserFromTokenStorage()) != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isAuthenticated(),
      builder: (ctx, snapshot) {
        if (snapshot.data ?? false) {
          return FloatingActionButton(
            onPressed: () {
              showFlexibleBottomSheet(
                minHeight: 0,
                initHeight: 0.5,
                maxHeight: 0.75,
                context: context,
                builder: (BuildContext context,
                    ScrollController scrollController,
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
        return const SizedBox.shrink();
      },
    );
  }
}
