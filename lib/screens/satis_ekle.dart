import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_test/data/cart_service.dart';
import 'package:firebase_test/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class SatisEkle extends StatefulWidget {


  SatisEkle({key, this.id}) : super(key: key);
  var id;
  @override
  State<SatisEkle> createState() => _SatisEkleState(last_id: id);
}

class _SatisEkleState extends State<SatisEkle> {
  final _formKey = GlobalKey<FormState>();

  var selectedTextController;


  _SatisEkleState({required this.last_id});
  var last_id;
  final saleNotsController = TextEditingController();
  final saleBasketController = TextEditingController();
  final saleDateController = TextEditingController();
  final saleSumPriceController = TextEditingController();

  late DatabaseReference dbRefSatis;
  late DatabaseReference dbRefUrun;

  @override
  void initState() {
    super.initState();
    dbRefUrun = FirebaseDatabase.instance.ref().child('tbl_urunler');
    last_id = int.parse(last_id) + 1;
    dbRefSatis = FirebaseDatabase.instance.ref().child('tbl_satislar/$last_id');
  }

  @override
  Widget build(BuildContext context) {
    var keep=CartService.getCart();
    return Scaffold(
      appBar: AppBar(
        title: Text('Satış Ekle'),
        actions: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ListView(
                    children: selectedTextController,
                  ),
                  DropDownField(
                    controller: saleBasketController,
                    labelText: 'Ürünler',
                    hintText: 'satılacak ürünleri seçiniz',
                    required: true,
                    items: satisList(),
                    onValueChanged: (value){
                      selectedTextController=value;
                      saleBasketController.clear();
                    },
                  ),
                  ListTile(
                    title: Text('test'),
                  ),
                  TextField(
                    controller: saleNotsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Notlar',
                      hintText: 'satış hakkında',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: saleSumPriceController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Toplam Fiyat',
                      hintText: '_',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        dbRefSatis.set({
                          'Id': last_id.toString(),
                          'Urunler': saleBasketController.text,
                          'Notlar': saleNotsController.text,
                          'Tarih': saleDateController.text,
                          'ToplamFiyat': saleSumPriceController.text
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ürün eklendi.')),
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Kaydet'),
                    color: Colors.green,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<String> satisList() {
    List<String> keep = <String>[];
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child('tbl_urunler');
    reference.onValue.listen((DatabaseEvent event) {
      for (final child in event.snapshot.children) {
        keep.add(child.value.toString());
      }
    });
    print("keep size:" + keep.length.toString());
    return keep;
  }
}
