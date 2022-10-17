import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UrunGuncelle extends StatefulWidget {
  const UrunGuncelle({Key? key, required this.urunID}) : super(key: key);

  final String urunID;

  @override
  State<UrunGuncelle> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UrunGuncelle> {
  final _formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockController = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('tbl_urunler');
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.child(widget.urunID).get();

    Map urun = snapshot.value as Map;

    productNameController.text = urun['Urun_adi'];
    productPriceController.text = urun['Fiyati'].toString();
    productStockController.text = urun['Stok'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Kaydı Güncelle'),
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
                  TextField(
                    controller: productNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ürün',
                      hintText: 'Ürün adını giriniz',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: productPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Birim Fiyatı',
                      hintText: '0,0',
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
                        'Urun_adi': productNameController.text,
                        'Fiyati': productPriceController.text,
                        'Stok': productStockController.text
                      };

                      dbRef
                          .child(widget.urunID)
                          .update(students)
                          .then((value) => {Navigator.pop(context)});
                    },
                    child: const Text('Kaydı Güncelle'),
                    color: Colors.blue,
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
}
