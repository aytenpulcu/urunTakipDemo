
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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

  late DatabaseReference dbRefSatis;
  late DatabaseReference dbRefUrun;

  @override
  void initState() {
    super.initState();
    dbRefSatis = FirebaseDatabase.instance.ref().child('tbl_satislar');
    dbRefUrun = FirebaseDatabase.instance.ref().child('tbl_urunler');
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
                  value: FirebaseAnimatedList(
                      query: dbRefUrun,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map urun_list = snapshot.value as Map;
                        urun_list['key'] = snapshot.key;

                        return urun_list as dynamic;
                      },
                ),
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
                    Map<String, String> sale = {
                      'Urunler': saleBasketController.text,
                      'Notlar': saleNotsController.text,
                      'Tarih': saleDateController.text,
                      'ToplamFiyat': saleSumPriceController.text
                    };

                    dbRefSatis.push().set(sale);

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