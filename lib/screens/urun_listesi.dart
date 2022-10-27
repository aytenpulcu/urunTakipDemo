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
  late String _search;
  @override
  List<Widget>? buildActions(BuildContext context) {
    Padding(
      padding: const EdgeInsets.only(
          bottom: 12.0, left: 12.0, right: 12.0),
      child: TextField(
        onChanged: (newvalue) {
          _search = newvalue;
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Type Here',
          icon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: (){
        if(query.isEmpty){
          close(context, null);
        }
        else{
          query='';
        }
      },
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: ()=>close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (_search != null) {
      _searchResult = createResult();
    }
    return _searchResult.first;
  }
  List<Widget> _searchResult = [];
  @override
  Widget buildSuggestions(BuildContext context) {

     if (_search != null) {
       _searchResult = createResult();
     }
     return _searchResult.first;
  }
  createResult() async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref().child('tbl_urunler');
    RegExp regExp = RegExp(
      "/*$_search/*",
      caseSensitive: false,
    );
    List<Widget> searchResult = [];

    reference
        .once()
        .then((DatabaseEvent list) {
      if (list != null) {

        for (var urun in list.snapshot.children) {
          var temp=urun.value as Map;
          temp['key']=urun.key;
          if (regExp.hasMatch(temp[urun.key])) {
            searchResult.add(addElement(
                name: temp[urun.key]["Urun_adi"],
                price: temp[urun.key]["Fiyatı"],
                stock: temp[urun.key]["Stok"],
                quantitySold: temp[urun.key]["SatilanMiktar"],
                currency: temp[urun.key]["ParaBirimi"],
                key: urun.key));
          }
        }
      }
    });
    return searchResult;
  }

  Widget addElement({required String name, price, stock, quantitySold, currency, key}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () {

        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                  ),
                  Text(
                    price.toString()+currency.toString(),
                  )
                ],
              ),
              Text(
                stock.toString(),
              ),
              Text(
                quantitySold.toString(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

