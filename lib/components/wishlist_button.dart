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
    return ElevatedButton(
      onPressed: onPressed,
      child: const Icon(Icons.bookmark_border),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        side: const BorderSide(
          width: 2.0,
          color: Colors.black,
        ),
        primary: isInWishlist ? background : foreground,
        onPrimary: isInWishlist ? foreground : background,
      ),
    );
  }
}
