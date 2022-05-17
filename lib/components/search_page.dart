import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  _SearchPage();

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onBackground,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: colorScheme.onSurface),
          ),
          child: TextField(
            onChanged: (value) {},
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Recherche ...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: const Material(),
    );
  }
}
