import 'package:flutter/material.dart';

class WishlistButton extends StatelessWidget {
  final Color background;
  final Color foreground;
  final bool isInWishlist;
  final Function() onPressed;

  const WishlistButton({
    Key? key,
    required this.background,
    required this.foreground,
    required this.isInWishlist,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 36.0,
        width: 36.0,
        child: Container(
          child: Expanded(
              child: Center(
                  child: IconButton(
            onPressed: onPressed,
            icon: Icon(isInWishlist ? Icons.bookmark : Icons.bookmark_border,
                color: isInWishlist ? foreground : background),
          ))),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isInWishlist ? background : foreground),
        ));
  }
}
