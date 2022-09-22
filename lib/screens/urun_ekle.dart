import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UrunEkle extends StatefulWidget {
  const UrunEkle({Key? key}) : super(key: key);


  @override
  State<UrunEkle> createState() => _UrunEkleState();
}

class _UrunEkleState extends State<UrunEkle> {

  final  productNameController = TextEditingController();
  final  productPriceController= TextEditingController();
  final  productStockController =TextEditingController();

  late DatabaseReference dbRef;
  late int lastId;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('tbl_urunler');
    Map temp=dbRef.limitToLast(1) as Map;
    lastId=temp.keys.last;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Ekle'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Image.asset('assets/images/product.png',height: 100,width: 100,),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: productNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Adı',
                    hintText: 'ürün adını girin',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: productPriceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Birim Fiyat',
                    hintText: '00,00',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: productStockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Stok',
                    hintText: '0',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  onPressed: () {
                    Map<String, String> students = {
                      'Id': lastId.toString(),
                      'Urun_adi': productNameController.text,
                      'Fiyati': productPriceController.text,
                      'Stok': productStockController.text,
                      'SatilanMiktar': '0',
                      'ParaBirimi': '₺',
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
      ),
    );
  }
}