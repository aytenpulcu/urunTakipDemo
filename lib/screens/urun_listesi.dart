import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_test/models/product.dart';
import 'package:firebase_test/screens/urun_ekle.dart';
import 'package:firebase_test/screens/urun_guncelle.dart';
import 'package:flutter/material.dart';

import '../blocs/cart_bloc.dart';
import '../models/cart.dart';
import 'cart_screen.dart';

class UrunList extends StatefulWidget {
  const UrunList({Key? key}) : super(key: key);

  @override
  State<UrunList> createState() => _UrunListState();
}

class _UrunListState extends State<UrunList> {
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('tbl_urunler');

  var lastID;
  late Map urunList;
  Widget listItem({required Map urunler}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            urunler['Urun_adi'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Birim Fiyatı: " + urunler['Fiyati'].toString() + "₺",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Stok: " + urunler['Stok'].toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          IconButton(
              onPressed: () {
                Product temp = Product.fromJson(urunler);
                CartBloc().addToCart(Cart(temp, 1));
              },
              icon: Icon(Icons.add_shopping_cart)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              UrunGuncelle(urunID: urunler['key'])));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                  reference.child(urunler['key']).remove();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        actions: [

          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: Icon(
                Icons.search_outlined,
                size: 30,
                color: Colors.white,
              )),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: reference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            urunList = snapshot.value as Map;
            urunList['key'] = snapshot.key;

            return listItem(urunler: urunList);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          reference.onValue.listen((DatabaseEvent event) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UrunEkle(
                        id: event.snapshot.children.last.key.toString())));
          });
        },
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

}

class MySearchDelegate extends SearchDelegate {

  List<String> searchTerms = findList();



  @override
  List<Widget> buildActions(BuildContext context) {

    return[
      IconButton(onPressed: (){
        query = '';
      }, icon: const Icon(Icons.clear))
    ];


  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      close(context, null);
    }, icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for(var fruit in searchTerms)
    {
      if(fruit.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(itemBuilder: (context,index){
      var result = matchQuery[index];
      return ListTile(
        title: Text(result),
      );
    },itemCount: matchQuery.length,);
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List<String> matchQuery = [];

    for(var fruit in searchTerms)
    {
      if(fruit.toLowerCase().contains(query.toLowerCase()))
      {
        matchQuery.add(fruit);
      }
    }

    return ListView.builder(itemBuilder: (context,index){
      var result = matchQuery[index];
      return ListTile(title: Text(result),);
    },itemCount: matchQuery.length,);
  }

  static List<String> findList() {
    List<String> keep=<String>[];
    DatabaseReference reference = FirebaseDatabase.instance.ref().child('tbl_urunler');
    reference.onValue.listen((DatabaseEvent event) {
      for (final child in event.snapshot.children) {
        keep.add(child.value.toString());
      }
    });
    print("keep size:" + keep.length.toString());
    return keep;
  }


}

