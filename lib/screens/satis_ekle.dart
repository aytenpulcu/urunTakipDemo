
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SatisEkle extends StatefulWidget {
  const SatisEkle({Key? key}) : super(key: key);

  @override
  State<SatisEkle> createState() => _SatisEkleState();
}

class _SatisEkleState extends State<SatisEkle> {

  final  saleNotsController = TextEditingController();
  final  saleBasketController = TextEditingController();
  final  saleDateController =TextEditingController();
  final  saleSumPriceController =TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Students');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Satış Ekle'),
        actions: [
          Icon(Icons.shopping_cart_outlined,size: 50,color: Colors.white,),
          const SizedBox(
            height: 30,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              children: [

                DropDownField(
                  controller: saleBasketController,
                  labelText: 'Ürünler',
                  hintText: 'satılacak ürünleri seçiniz',
                ),

                ListView(
                  children: [
                    Text('data')
                  ],
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
                    Map<String, String> students = {
                      'Urunler': saleBasketController.text,
                      'Notlar': saleNotsController.text,
                      'Tarih': saleDateController.text,
                      'ToplamFiyat': saleSumPriceController.text
                    };

                    dbRef.push().set(students);

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

    );
  }
}