

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
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage(list: urunList))),
              icon: Icon(
                Icons.search_outlined,
                size: 30,
                color: Colors.white,
              )
          ),
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
            keepID(event.snapshot.children.last.key.toString());
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

  keepID(String length) {
    print("len" + length.toString());
  }
}

class SearchPage extends StatelessWidget {
  SearchPage({Key? key, required this.list}) : super(key: key);
  final Map list;

  @override
  Widget build(BuildContext context) {
    Map found=Map();
    final List<int> colorCodes = <int>[600, 500, 100];
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            onSubmitted: (value) {
              list.keys.forEach((element) {
                if (element==value){
                  found[element]=list[element];
                }
              });
            },
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {

                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
          ),
        ),
      )),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: found.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                color: Colors.amber[colorCodes[index]],
                child: Center(child: Text('Entry ${found[index]}')),
              );
            }
        )
      ),
    );
  }
}
