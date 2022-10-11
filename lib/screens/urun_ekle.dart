import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UrunEkle extends StatefulWidget {
  UrunEkle({key, this.id});

  var id;
  @override
  State<UrunEkle> createState() => _UrunEkleState(last_id: id);
}

class _UrunEkleState extends State<UrunEkle> {
  final _formKey = GlobalKey<FormState>();



  _UrunEkleState({required this.last_id});
  var last_id;
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockController = TextEditingController();
  static const validate = false;
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    last_id = int.parse(last_id) + 1;
    dbRef = FirebaseDatabase.instance.ref().child('tbl_urunler/$last_id');
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/product.png',
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: productNameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length<3) {
                        return 'Lütfen uygun bir değer giriniz.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Adı',
                      hintText: 'ürün adını girin',

                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: productPriceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty ) {
                        return 'Lütfen bir değer giriniz.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Birim Fiyat',
                      hintText: '00,00',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: productStockController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir değer giriniz.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Stok',
                      hintText: '0',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {dbRef.set({
                          'Id': last_id.toString(),
                          'Urun_adi': productNameController.text,
                          'Fiyati': productPriceController.text,
                          'Stok': productStockController.text,
                          'SatilanMiktar': '0',
                          'ParaBirimi': '₺',
                        });
                        
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ürün eklendi.')),
                          );

                        Navigator.pop(context);
                        }
                        
                      },
                      child: const Text('Kaydet'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
