import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/category_model.dart';
import 'package:ungexercies/models/product_model.dart';

import 'package:ungexercies/utility/my_style.dart';

class SyncDataByCategory extends StatefulWidget {
  @override
  _SyncDataByCategoryState createState() => _SyncDataByCategoryState();
}

class _SyncDataByCategoryState extends State<SyncDataByCategory> {
  List<GenderModel> genderModelList = [];
  String selectedGender;
  List<String> categories = List();
  List<CategoryModel> categoryModels = List();

  int index = 0;
  int numx = 0;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlMin = TextEditingController();
  TextEditingController ctrlMax = TextEditingController();

  Future<Null> genProductSearch() async {
    await Firebase.initializeApp().then((value) async {
      try {
        await FirebaseFirestore.instance
            .collection('product')
            .where('urlImage', isNotEqualTo: '')
            .get()
            .then((value) async {
          int _num = 0;

          for (var item in value.docs) {
            Map<String, dynamic> mapName = Map();
            mapName['name'] = item['name'];
            mapName['urlImage'] = item['urlImage'];
            mapName['categoryName'] = item['categoryName'];
            mapName['itemCategory'] = item['itemCategory'];

            await Firebase.initializeApp().then((value) async {
              await FirebaseFirestore.instance
                  .collection('productsearch')
                  .doc()
                  .set(mapName);
            });

            _num++;
            print('no==>>$_num');
          }
          setState(() {
            numx = _num;
          });
        });
      } catch (e) {
        print('e==>>${e.toString()}');
      }
    });
  }

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

  Future<Null> freshDataByCategory(syntxt) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          // .limit(300)

          .where('itemCategory', isEqualTo: syntxt)
          .snapshots()
          .listen((event) async {
        for (var snapshot in event.docs) {
          // ProductOutModel model = ProductOutModel.fromMap(snapshot.data());
          String _keyword = snapshot.id;

          // print('snapshot.id==>>${snapshot.id}');
          // print('snapshot.reference==>>${snapshot.reference}');

//           I/flutter ( 8918): snapshot.id==>>01-0010
// I/flutter ( 8918): snapshot.reference==>>DocumentReference(product/01-0010)

          String urlAPI =
              'http://43.229.149.11:8080/SMLJavaRESTService/v3/api/product/$_keyword';
          Map<String, String> headers = Map();
          headers['GUID'] = 'smlx';
          headers['provider'] = 'DATA';
          headers['databasename'] = 'wawa2';

          await Dio()
              .get(urlAPI, options: Options(headers: headers))
              .then((value) async {
            var result = value.data;
            int count = 0;

            for (var map in result['data']) {
              setState(() {
                loading = true;
              });
              count++;
              ProductModel model = ProductModel.fromJson(map);
              var result = value.data['data']['images'];
              var categoryName = value.data['data']['category_name'];
              var itemCategory = value.data['data']['item_category'];
              // item_category

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
                        price: model.barcodes[i].price,
                        unit_code: model.barcodes[i].unitCode);
                    Map<String, dynamic> mapBarcode = barcodeModel.toMap();

                    await FirebaseFirestore.instance
                        .collection('product')
                        .doc(model.code)
                        .collection('barcodes')
                        .doc(model.barcodes[i].barcode)
                        .set(mapBarcode)
                        .then((value) => print('successByCategory==>$count'));
                  }

                  //
                });
              });
            }
            setState(() {
              loading = false;
            });
          }); // end.

        }
      });
    });
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
      GenderModel('001', "ของใช้อื่นๆ"),
      GenderModel('002', "ข้าวสาร/เครื่องปรุง/อาหารแห้ง"),
      GenderModel('004', "เครื่องดื่ม/นม"),
      GenderModel('005', "แอลกอฮอล"),
      GenderModel('006', "บุหรี่"),
      GenderModel('007', "สินค้า แลกเปลี่ยน"),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Syn Data to Database'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent[700]),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณาระบุ รหัส category ';
                    }
                    return null;
                  },
                  controller: ctrlMin,
                  decoration: InputDecoration(
                      // fillColor: Colors.white,
                      // filled: true,
                      labelText: 'รหัส Category',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green[700]),
                      helperText: 'ระบุเลขรหัส เช่น 001, 002, 003,004,005,...',
                      helperStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green[300]),
                      prefixIcon: Icon(
                        Icons.edit,
                        color: Colors.green[700],
                        size: 32,
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              // RaisedButton.icon(
              //     onPressed: () {
              //       freshDataByCategory(ctrlMin.text);
              //     },
              //     icon: Icon(Icons.wifi_protected_setup),
              //     label: Text('Sync')),

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
                              freshDataByCategory(ctrlMin.text);
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
                        ' ',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600]),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              // RaisedButton.icon(
              //     onPressed: () {
              //       genProductSearch();
              //     },
              //     icon: Icon(Icons.sync),
              //     label: Text('Sync ตาราง product Image'))
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
