import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/product_model.dart';
import 'package:ungexercies/utility/my_style.dart';

class ChooseProduct extends StatefulWidget {
  final ProductModel productModel;
  final String doct;
  ChooseProduct({@required this.productModel, @required this.doct});
  @override
  _ChooseProductState createState() => _ChooseProductState();
}

class _ChooseProductState extends State<ChooseProduct> {
  ProductModel productModel;
  String doct;
  List<BarcodeModel> barcodeModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    doct = widget.doct;

    readProduct();
    print('doct==>>> $doct');
  }

  Future<Null> readProduct() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(doct)
          .collection('barcodes')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          BarcodeModel model = BarcodeModel.fromMap(item.data());
          setState(() {
            barcodeModels.add(model);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(productModel == null ? 'Choose Product' : productModel.name),
      ),
      body: barcodeModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: barcodeModels.length,
              itemBuilder: (context, index) => Row(
                children: [
                  Expanded(flex: 1,
                    child: Text('หน่วย :'),),
                  Expanded(flex: 1,
                    child: Text(barcodeModels[index].unit_code)),
                  Expanded(flex: 1,
                    child: Text('ราคา :')),
                  Expanded(flex: 1,
                                      child: Text(
                      barcodeModels[index].price.toString(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
