import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_test/screens/cart_screen.dart';
import 'package:firebase_test/screens/satis_ekle.dart';
import 'package:flutter/material.dart';

class SatisList extends StatefulWidget {
  const SatisList({Key? key}) : super(key: key);

  @override
  State<SatisList> createState() => _SatisListState();
}

class _SatisListState extends State<SatisList> {

  Query dbRef = FirebaseDatabase.instance.ref().child('tbl_satislar');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('tbl_satislar');

  Widget listItem({required Map satislar}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),

      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            satislar['Notlar'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            satislar['ToplamFiyat'].toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            satislar['Id'].toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                 // Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateRecord(studentKey: student['key'])));
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
                  reference.child(satislar['key']).remove();
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
          title: const Text('Satışlar'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined,size: 40,color: Colors.white,),
              onPressed: () {
                Navigator.push(context,  MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

              Map satislar_list = snapshot.value as Map;
              satislar_list['key'] = snapshot.key;

              return listItem(satislar: satislar_list);

            },
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SatisEkle())
          );
        },
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}