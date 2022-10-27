
import 'package:firebase_test/models/product.dart';

import '../models/cart.dart';
import 'package:firebase_database/firebase_database.dart';
class CartService {
  static List<Cart> cartItems = <Cart>[];

  CartService._internal();

  static CartService _singleton = CartService._internal();
  static DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('tbl_sepet/');
  factory CartService() {
    return _singleton;
  }

  static void addToCart(Cart item) {
    cartItems.add(item);
    dbRef.set({'$item':item.product.id});
  }

  static void removeFromCart(Cart item) {
    cartItems.remove(item);
  }

  static List<Cart> getCart() {
    if(cartItems.isEmpty){
      dbRef.onValue.listen((DatabaseEvent event) {
        event.snapshot.children.forEach(
                (element) {
                  Cart n=Cart(Product(0,element.value.toString(),'₺',0,0,0), 1);
                  cartItems.add(n);
                }
        );
      });
    }
    return cartItems;
  }
}
