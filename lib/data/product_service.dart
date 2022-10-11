import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../models/product.dart';

class ProductService{
  static List<Product> products=<Product>[];

  ProductService._internal();

  static ProductService _singleton = ProductService._internal();

  factory ProductService(){
    return _singleton;
  }
  static List<Product> getAll() {

   final temp=readDataFirebase();
   print(temp);
   return products;
  }




}

Future<StreamSubscription<DatabaseEvent>> readDataFirebase() async {
  final ref = FirebaseDatabase.instance.ref();

  final data=await ref.onValue.listen((event) {
    for (final child in event.snapshot.children) {
      print(child);
    }
  }, onError: (error) {
    print("error");
  });
  print(data.runtimeType);
  return data;
}