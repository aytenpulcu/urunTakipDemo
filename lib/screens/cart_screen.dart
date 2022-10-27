import 'package:firebase_test/blocs/cart_bloc.dart';
import 'package:flutter/material.dart';

import '../models/cart.dart';

class CartScreen extends StatelessWidget{  CartBloc cb=CartBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sepet"),
      ),
      body: StreamBuilder(
        stream: cb.getStream,
        initialData: cb.getCart(),
        builder: (context,snapshot){
          return buildCart(snapshot);
        },
      ),
    );
  }

  Widget buildCart(AsyncSnapshot<Object?> snapshot) {
    final list=snapshot.data as List<Cart>;
    return ListView.builder(
      itemCount: list.length,
        itemBuilder: (BuildContext context,index){
        return ListTile(
          title: Text(list[index].product.name!),
          subtitle: Text(list[index].product.price.toString()),
          trailing: IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: (){
              cb.removeFromCart(list[index]);
            },
          ),
        );
        }
    );
  }

}