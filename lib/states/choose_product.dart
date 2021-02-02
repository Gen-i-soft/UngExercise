import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/product_cloud_model.dart';
import 'package:ungexercies/models/sqlite_model.dart';
import 'package:ungexercies/utility/dialog.dart';

import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/utility/sqlite_helper.dart';

class ChooseProduct extends StatefulWidget {
  final ProductCloudModel productModel;
  final String doct;
  ChooseProduct({@required this.productModel, @required this.doct});
  @override
  _ChooseProductState createState() => _ChooseProductState();
}

class _ChooseProductState extends State<ChooseProduct> {
  List<int> amounts = List();
  List<double> subTotals = List();
  double total = 0;

  ProductCloudModel productModel;
  String doct;
  List<BarcodeModel> barcodeModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    print('#####urlImage ===>> ${productModel.urlImage}');
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
          amounts.add(0);
          subTotals.add(0);

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
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: MyStyle().primartColor),
          onPressed: () {
            if (total == 0) {
              normalDialog(context, 'ไม่มีสินค้า', 'กรุณาเลือกสินค้า');
            } else {
              addValueToCart();
            }
          },
          child: Text('Add to Cart')),
      appBar: AppBar(
        title:
            Text(productModel == null ? 'Choose Product' : productModel.name),
      ),
      body: barcodeModels.length == 0
          ? MyStyle().showProgress()
          : Column(
              children: [
                buildShowImage(),
                Container(
                  decoration: BoxDecoration(color: MyStyle().primartColor),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: MyStyle().titleH3White('หน่วย :'),
                        ),
                        Expanded(
                            flex: 1, child: MyStyle().titleH3White('ราคา :')),
                        Expanded(
                            flex: 1, child: MyStyle().titleH3White('จำนวน :')),
                        Expanded(
                            flex: 1, child: MyStyle().titleH3White('ผลรวม :')),
                      ],
                    ),
                  ),
                ),
                buildListView(),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyStyle().titleH2dark('Total:'),
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.yellow[600]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyStyle().titleH3(total.toString()),
                            ],
                          ),
                        )),
                  ],
                )
              ],
            ),
    );
  }

  Container buildShowImage() {
    return Container(
        width: 250,
        margin: EdgeInsets.only(top: 16.0, bottom: 16),
        child: CachedNetworkImage(
          imageUrl: productModel.urlImage,
          placeholder: (context, url) => MyStyle().showProgress(),
          errorWidget: (context, url, error) => Image.asset('images/image.png'),
        ));
  }

  ListView buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: barcodeModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(flex: 1, child: Text(barcodeModels[index].unit_code)),
          Expanded(
            flex: 1,
            child: Text(
              barcodeModels[index].price.toString(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (amounts[index] != 0) {
                      setState(() {
                        amounts[index]--;
                        subTotals[index] = barcodeModels[index].price *
                            double.parse(amounts[index].toString());
                        total = 0;
                        for (var item in subTotals) {
                          total = total + item;
                        }
                      });
                    }
                  },
                ),
                Text(amounts[index].toString()),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    print('You click Add at index ===>> $index');
                    setState(() {
                      amounts[index]++;
                      subTotals[index] = barcodeModels[index].price *
                          double.parse(amounts[index].toString());
                      total = 0;
                      for (var item in subTotals) {
                        total = total + item;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(subTotals[index].toString()))
        ],
      ),
    );
  }

  Future<Null> addValueToCart() async {
    String code = doct;
    String name = productModel.name;

    String barcodes = modelToString(0);
    String prices = modelToString(1);
    String unitcodes = modelToString(2);
    String listAmounts = amounts.toString();
    String listSubtotals = subTotals.toString();

    print(
        'code = $code, name=$name, barcode= $barcodes, prices=$prices, unitcodes=$unitcodes, listAmount=$listAmounts, listSubtotals=$listSubtotals');

    SQLiteModel model = SQLiteModel(
        code: code,
        name: name,
        barcodes: barcodes,
        prices: prices,
        units: unitcodes,
        amounts: listAmounts,
        subtotals: listSubtotals);

    Map<String, dynamic> map = model.toMap();
    await SQLiteHelper().insertValueToSQLite(map).then(
          (value) => Navigator.pop(context),
        );
  }

  String modelToString(int index) {
    List<String> strings = List();

    switch (index) {
      case 0:
        for (var item in barcodeModels) {
          strings.add(item.barcode);
        }
        return strings.toString();

        break;
      case 1:
        for (var item in barcodeModels) {
          strings.add(item.price.toString());
        }
        return strings.toString();

        break;
      case 2:
        for (var item in barcodeModels) {
          strings.add(item.unit_code);
        }
        return strings.toString();

        break;

      default:
    }
  }
}
