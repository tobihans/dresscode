import 'package:dresscode/components/floating_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/components/app_bar.dart';
import 'package:dresscode/components/app_drawer.dart';
import '../api/services/wishlist_service.dart';
import 'item_details.dart';

class Wishlist extends StatefulWidget{
  final WishlistService wishlistService;

  const Wishlist({
    Key? key,
    required this.wishlistService,
  }) : super(key: key);
  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist>{
  late WishlistService _wishlistService;

  @override
  void initState() {
    _wishlistService = widget.wishlistService;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const FloatingBtn(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 12.0),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child:const  Text(
              "Mes souhaits",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
            /*  Uncomment for deploying  */
            /* FutureBuilder<List<Product>>(
              future: _wishlistService.getWishlist(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var wProducts = snapshot.data;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: wProducts?.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                      ),
                      itemBuilder: (context, index) {
                        return ProductCardItem(wProducts![index], _wishlistService);
                      }
                  );
                }else if (snapshot.hasError) {
                  return const Center(child: Text("Une erreur est survenue"));
                }else{
                  return const Center(child: Text("Aucun article ajouté à la liste des souhaits"));
                }
              },
            ),*/
            /* An example of the single card. This part has to be delete when deploying*/
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3/4,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                      height: 150,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: NetworkImage("https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHw%3D&w=1000&q=80"),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:const [
                                Text("Un nom d'article", style: TextStyle(fontSize: 16,), overflow:TextOverflow.ellipsis,),
                                SizedBox(height: 4.0,),
                                Text("12500 FCFA", style: TextStyle(fontSize: 16,), overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: (){

                            },
                            icon: const Icon(Icons.delete))
                      ],
                    )
                  ]
                ),
              );
            })
          ]
        ),
    );
  }
}

class ProductCardItem extends StatelessWidget{
  final product;
  final wService;
  const ProductCardItem(this.product, this.wService);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder:(context)=> const ItemDetailsScreen()));
      },
      child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              height: 200,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(product.images[0].url),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: const TextStyle(fontSize: 16,),overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4.0,),
                        Text(product.price, style: const TextStyle(fontSize: 18,),overflow: TextOverflow.ellipsis)
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: (){
                      wService.removeFromWishlist(product);
                    },
                    icon: const Icon(Icons.delete))
              ],
            )
          ]
      ),
    );
  }
}



