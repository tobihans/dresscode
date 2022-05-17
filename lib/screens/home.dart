import 'package:dresscode/api/services/category_service.dart';
import 'package:dresscode/components/app_drawer.dart';
import 'package:dresscode/models/category.dart';
import 'package:dresscode/models/page.dart' as page;
import 'package:dresscode/requests/page_request.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/floating_btn.dart';
import 'package:dresscode/components/home_hero.dart';
import 'package:dresscode/components/category_widget.dart';
import 'package:dresscode/components/top_model.dart';

import '../api/services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel homeViewModel = HomeViewModel(
    productService: ProductService(),
    categoryService: CategoryService(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const HomeHero(
                text: 'Visiter notre collection',
              ),
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    page.Page<Category> response = snapshot.data;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const Text('Nos catégories',
                                style: TextStyle(fontSize: 18)),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (Category category in response.content)
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: CategoryWidget(
                                      category: category,
                                    ),
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  }
                }
                return const SizedBox();
              },
              future: homeViewModel.loadCategories(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child:
                  const Text('Les top modèles', style: TextStyle(fontSize: 18)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  9,
                  (e) => TopModel(
                    name: 'Jan$e',
                    url:
                        'https://source.unsplash.com/random/1600x900?mode&clothe&dress&style&beautiful&sig=10$e',
                  ),
                ).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: const Text('Les articles phares',
                  style: TextStyle(fontSize: 18)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(9, (_) => const Material()).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeViewModel {
  final ProductService productService;
  final CategoryService categoryService;
  PageRequest categoryParams = PageRequest(
    pageNumber: 0,
    pageSize: 10,
  );
  PageRequest productParams = PageRequest(
    pageNumber: 0,
    pageSize: 20,
  );

  HomeViewModel({
    required this.productService,
    required this.categoryService,
  });

  Future<page.Page<Category>> loadCategories() async {
    return await categoryService.getCategories(categoryParams);
  }
}
