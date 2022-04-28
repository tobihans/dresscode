import 'package:flutter/material.dart';
import 'package:dresscode/models/product.dart';
import 'package:dresscode/components/search_row.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.journals}) : super(key: key);
  final List<dynamic> journals;

  @override
  _SearchPage createState() => _SearchPage(journals: journals);
}

class _SearchPage extends State<SearchPage> {
  _SearchPage({Key? key, required this.journals});
  List<dynamic> journals;
  late List<dynamic> duplicatedJournals1 = [];
  late List<dynamic> duplicatedJournals = [];
  late List<String> duplicatedJournalsToString = [];

  @override
  void initState() {
    super.initState();
    duplicatedJournals1.addAll(journals);
    duplicatedJournals.addAll(journals);
    for (var element in duplicatedJournals) {
      duplicatedJournalsToString.add(element['name'].toString().toLowerCase() + ' ' + element['description'].toString().toLowerCase() + ' ' + element['price'].toString().toLowerCase());
    }
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(duplicatedJournalsToString);
    if(query.isNotEmpty) {
      List<int> dummySearchListDataIndex = [];
      dummySearchList.forEach((element) {
        if(element.contains(query.toLowerCase())) {
          dummySearchListDataIndex.add(dummySearchList.indexOf(element));
        }
      });
      setState(() {
        journals.clear();
        for (var i = 0; i<duplicatedJournals.length; i++) {
          if(dummySearchListDataIndex.contains(i)) {
            journals.add(duplicatedJournals[i]);
          }
        }
      });
    }
    else {
      setState(() {
        journals.clear();
        journals.addAll(duplicatedJournals);
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          width: double.infinity,
          height: 40,

          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5)
          ),

          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: _searchController,
            decoration: InputDecoration(
                hintText: 'Recherche ...',
                prefixIcon: const Icon(Icons.search, color: Colors.white,),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white,),
                  onPressed: () {
                    /* Clear the research field */
                    _searchController.clear();
                  },
                ),
                border: InputBorder.none
            ),
          ),
        ),
      ),

      body: ListView.builder(
          shrinkWrap: true,
          itemCount: journals.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {

            Product _thisProduct = Product.fromMap({
              'code':journals[index]['code'],
              'name':journals[index]['name'],
              'description':journals[index]['description'],
              'price':journals[index]['price'],
              'image':journals[index]['image'],
            });

            return SearchRow(product:_thisProduct);
          }
      ),

    );
  }
}