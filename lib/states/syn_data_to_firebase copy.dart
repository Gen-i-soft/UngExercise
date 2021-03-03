import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/product_model.dart';
import 'package:ungexercies/utility/my_style.dart';

class SynDataToFirebase extends StatefulWidget {
  @override
  _SynDataToFirebaseState createState() => _SynDataToFirebaseState();
}

class _SynDataToFirebaseState extends State<SynDataToFirebase> {
  bool loading = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlMin = TextEditingController();
  TextEditingController ctrlMax = TextEditingController();

  Future<Null> freshDataToFirebase(int minPage, int maxPage) async {
    for (var page = minPage; page <= maxPage; page++) {
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
           setState(() {
                  loading = true;
                });
          ProductModel model = ProductModel.fromJson(map);
          print('code ==>> ${model.code}');
          String urlAPI =
              'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/${model.code}';

          await Dio()
              .get(urlAPI, options: Options(headers: headers))
              .then((value) async {
            var result = value.data['data']['images'];

            // await Dio().post(
            //   urlAPI,
            //   data: [],
            //   options: Options(headers: headers)
            // );

            String urlImage = '';
            if (result != null) {
              for (var item in result) {
                urlImage = item['uri'];
                print('urlImage of a ${model.code}==>> $urlImage');
              }
            }

            Map<String, dynamic> mapName = Map();
            mapName['name'] = model.name;
            mapName['urlImage'] = urlImage;

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
          }); // end.
           setState(() {
                  loading = false;
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
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent[700]),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาระบุค่าต่ำสุด';
                  }
                  return null;
                },
                controller: ctrlMin,
                decoration: InputDecoration(
                    // fillColor: Colors.white,
                    // filled: true,
                    labelText: 'ค่าตำ่สุด',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[700]),
                    helperText: 'ระบุค่าตำ่สุด',
                    helperStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[300]),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.green[700],
                      size: 32,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700]),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณาระบุค่าสูงสุด';
                  }
                  return null;
                },
                controller: ctrlMax,
                decoration: InputDecoration(
                    // fillColor: Colors.white,
                    // filled: true,
                    labelText: 'ค่าสูงสุด',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[700]),
                    helperText: 'ระบุค่าสูงสุด',
                    helperStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[300]),
                    prefixIcon: Icon(
                      Icons.lock_open_outlined,
                      size: 32,
                      color: Colors.green[700],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          //valid
                          freshDataToFirebase(int.parse(ctrlMin.text.trim()),
                              int.parse(ctrlMax.text.trim()));
                        } else {
                          //invalid
                        }
                      },
                      child: Text('This is Syn Data')),
                ],
              ),

             loading? MyStyle().showProgress()  : Container(child: Text('ระบบทำงานเสร็จเรียนร้อยแล้วครับ',style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold,color: Colors.red[600]
              ),),)
            ],
          )),
    );
  }
}
