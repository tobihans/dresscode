import 'package:flutter/material.dart';

class TopModel extends StatelessWidget {
  final String name;
  final String url;

  const TopModel({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(url),
          ),
          Container(
            padding: const EdgeInsets.only(top: 2.5),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
