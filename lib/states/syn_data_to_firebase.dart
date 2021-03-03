import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/category_model.dart';
import 'package:ungexercies/models/product_model.dart';

import 'package:ungexercies/utility/my_style.dart';

class SynDataToFirebase extends StatefulWidget {
  @override
  _SynDataToFirebaseState createState() => _SynDataToFirebaseState();
}

class _SynDataToFirebaseState extends State<SynDataToFirebase> {
  List<GenderModel> genderModelList = [];
  String selectedGender;
  List<String> categories = List();
  List<CategoryModel> categoryModels = List();

  int index = 0;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlMin = TextEditingController();
  TextEditingController ctrlMax = TextEditingController();

  // Future<Null> getCategory() async {
  //   await Firebase.initializeApp().then((value) async {
  //     await FirebaseFirestore.instance
  //         .collection('category')
  //         // .limit(300)

  //         .snapshots()
  //         .listen((event) async {
  //       // final data = event.docs;
  //       for (var snapshot in event.docs) {
  //         CategoryModel model = CategoryModel.fromMap(snapshot.data());
  //         // categories.add(model.name); >>worked
  //         // categoryModels.add(model);
  //         // var _model = CatrgoryModel(index, model.name).toString();
  //         categories.add(model.name);
  //       }
  //     });
  //   });
  // }

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
        int _index = 0;
        for (var map in result['data']) {
          _index++;
          setState(() {
            loading = true;
          });
          ProductModel model = ProductModel.fromJson(map);
          // print('code ==>> ${model.code}');
          String urlAPI =
              'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/${model.code}';

          await Dio()
              .get(urlAPI, options: Options(headers: headers))
              .then((value) async {
            var result = value.data['data']['images'];
            var categoryName = value.data['data']['category_name']; //ok jaa
            var itemCategory = value.data['data']['item_category'];

            //on off
            //datetime

            // await Firebase.initializeApp().then((value) async {
            //   await FirebaseFirestore.instance
            //       .collection('category')
            //       .where('itemCategory', isEqualTo: itemCategory)
            //       // .limit(300)

            //       .snapshots()
            //       .listen((event) async {
            //     // final data = event.docs;

            //     if (event.docs.length != 0) {
            //       var _id = event.docs[index].id; //ต้องใช้ index ช่วย
            //       print('_id >>> $_id');
            //       var _reference = event.docs[index].reference;
            //       print('_reference>> $_reference');
            //       //  Map<String, dynamic> mapName = Map();
            //       // mapName['name'] = categoryName;
            //       // mapName['itemname'] = itemCategory;

            //       // await Firebase.initializeApp().then((value) async {
            //       //   await FirebaseFirestore.instance
            //       //       .collection('category')

            //       //       .set(mapName);
            //       // });

            //     } else {
            //       print('num >>>มีค่าว่าง');
            //       // Map<String, dynamic> mapName = Map();
            //       // mapName['name'] = categoryName;
            //       // mapName['itemname'] = itemCategory;

            //       // await Firebase.initializeApp().then((value) async {
            //       //   await FirebaseFirestore.instance
            //       //       .collection('category')
            //       //        .doc()

            //       //       .set(mapName);
            //       // });
            //     }
            //     // for (var snapshot in event.docs) {
            //     //   CategoryModel model = CategoryModel.fromMap(snapshot.data());
            //     //   // categories.add(model.name); >>worked
            //     //   // categoryModels.add(model);
            //     //   // var _model = CatrgoryModel(index, model.name).toString();
            //     //   categories.add(model.name);
            //     // }
            //   });
            // });

            String urlImage = '';
            if (result != null) {
              for (var item in result) {
                urlImage = item['uri'];
                // print('urlImage of a ${model.code}==>> $urlImage');
              }
            }

            Map<String, dynamic> mapName = Map();
            mapName['name'] = model.name;
            mapName['urlImage'] = urlImage;
            mapName['categoryName'] = categoryName;
            mapName['itemCategory'] = itemCategory;

            await Firebase.initializeApp().then((value) async {
              await FirebaseFirestore.instance
                  .collection('product')
                  .doc(model.code)
                  .set(mapName)
                  .then((value) async {
                for (var i = 0; i < model.barcodes.length; i++) {
                  BarcodeModel barcodeModel = BarcodeModel(
                      barcode: model.barcodes[i].barcode,
                      price: double.parse(model.barcodes[i].price.toString()) ,
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

        }
        setState(() {
          loading = false;
        });
        setState(() {
          index = _index;
        });
      }).catchError((res) {
        print('Error on Dio==> ${res.toString()}');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // freshDataByCategory();
  }

  @override
  Widget build(BuildContext context) {
    genderModelList = [
      GenderModel('1', "เครื่องดื่ม/นม"),
      GenderModel('2', "Female"),
      GenderModel('3', "Other")
    ];
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
                    labelText: 'ค่าต่ำสุด',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[700]),
                    helperText: 'ระบุค่าต่ำสุด =1',
                    helperStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[300]),
                    prefixIcon: Icon(
                      Icons.edit,
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
                    helperText: 'ระบุค่าสูงสุด =2080',
                    helperStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[300]),
                    prefixIcon: Icon(
                      Icons.edit,
                      size: 32,
                      color: Colors.green[700],
                    )),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'จำนวนฟิล์ดทั้งหมด $index',
              //       style: TextStyle(
              //           fontSize: 30,
              //           color: Colors.red[700],
              //           fontWeight: FontWeight.bold),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 200,height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //valid
                              freshDataToFirebase(int.parse(ctrlMin.text.trim()),
                                  int.parse(ctrlMax.text.trim()));
                            } else {
                              //invalid
                            }
                          },
                          child: Text('Sync Data',style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 24),)),
                    ),
                  ),
                ],
              ),
              loading
                  ? MyStyle().showProgress()
                  : Container(
                      child: Text(
                        '',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600]),
                      ),
                    ),

            //   Center(
            //     child: new Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         DropdownButtonHideUnderline(
            //           child: new DropdownButton<String>(
            //             hint: new Text("เลือก Category"),
            //             value: selectedGender,
            //             isDense: true,
            //             onChanged: (String newValue) {
            //               setState(() {
            //                 selectedGender = newValue;
            //               });
            //               print(selectedGender);
            //             },
            //             items: genderModelList.map((GenderModel map) {
            //               return new DropdownMenuItem<String>(
            //                 value: map.name,
            //                 child: new Text(map.name,
            //                     style: new TextStyle(color: Colors.black)),
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
             ],
          )),
    );
  }
}

class GenderModel {
  String id;
  String name;
  @override
  String toString() {
    return '$id $name';
  }

  GenderModel(this.id, this.name);
}
