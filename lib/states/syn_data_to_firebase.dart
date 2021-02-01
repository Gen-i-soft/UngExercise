import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/product_model.dart';

class SynDataToFirebase extends StatefulWidget {
  @override
  _SynDataToFirebaseState createState() => _SynDataToFirebaseState();
}

class _SynDataToFirebaseState extends State<SynDataToFirebase> {
  Future<Null> freshDataToFirebase(int maxPage) async {
    for (var page = 1; page <= maxPage; page++) {
      String path =
          'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product?page=$page&size=20';
      Map<String, String> headers = Map();
      headers['GUID'] = 'smlx';
      headers['provider'] = 'DATA';
      headers['databasename'] = 'wawa2';
      
      await Dio()
          .get(path, options: Options(headers: headers))
          .then((value) async {
        // print('value==>${value.toString()}');
        var result = value.data;
        // int index = 0;
        for (var map in result['data']) {
          // print('map===>> $map ');
          ProductModel model = ProductModel.fromJson(map);
          print(
              'name Product ===>> ${model.name}, จำนวนราคา ==>> ${model.barcodes.length}');
      
          Map<String, dynamic> mapName = Map();
          mapName['name'] = model.name;
      
          await Firebase.initializeApp().then((value) async {
            await FirebaseFirestore.instance
                .collection('product')
                .doc(model.code)
                .set(mapName)
                .then((value) async {
              for (var i = 0; i < model.barcodes.length; i++) {
                BarcodeModel barcodeModel = BarcodeModel(
                    barcode: model.barcodes[i].barcode,
                    price: model.barcodes[i].price,
                    unit_code: model.barcodes[i].unitCode);
                Map<String, dynamic> mapBarcode = barcodeModel.toMap();
      
                await FirebaseFirestore.instance
                    .collection('product')
                    .doc(model.code)
                    .collection('barcodes')
                    .doc(model.barcodes[i].barcode)
                    .set(mapBarcode)
                    .then((value) => print('success'));
              }
              //
            });
          });
        }
      }).catchError((res) {
        print('Error on Dio==> ${res.toString()}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syn Data to Database'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () => freshDataToFirebase(1),
              child: Text('This is Syn Data')),
        ],
      ),
    );
  }
}
