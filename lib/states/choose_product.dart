import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/product_cloud_model.dart';
import 'package:ungexercies/models/sqlite_model.dart';
import 'package:ungexercies/utility/dialog.dart';

import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/utility/sqlite_helper.dart';

class ChooseProduct extends StatefulWidget {
  final Function onAdItem;
  final DocumentSnapshot products;
  // final String doct;
  ChooseProduct({@required this.products, @required this.onAdItem});
  @override
  _ChooseProductState createState() => _ChooseProductState();
}

class _ChooseProductState extends State<ChooseProduct> {
  List<int> amounts = List();
  List<double> subTotals = List();
  double total = 0;

  ProductCloudModel productModel;
  DocumentSnapshot products;
  String doct;
  List<BarcodeModel> barcodeModels = List();
  double screen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // productModel = widget.productModel;
    // print('#####urlImage ===>> ${productModel.urlImage}');
    doct = widget.products.id;
    products = widget.products;

    readProduct();
    // print('doct==>>> $doct');
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
    screen = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        //   children: [

        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //       primary: Colors.black,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(15)),
        //       shadowColor: Colors.black),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   child: Text(
        //     'ยกเลิก',
        //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //       primary: MyStyle().primartColor,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(15)),
        //       shadowColor: Colors.black),
        //   onPressed: () {
        //     if (total == 0) {
        //       normalDialog(context, 'ไม่มีรายการสินค้า', 'กรุณาเลือกสินค้าก่อนครับ');
        //     } else {
        //       addValueToCart();
        //     }
        //   },
        //   child: Text(
        //     'หยิบใส่ตะกร้า',
        //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        //   ),
        // ),
        //   ],
        // ),

        body: barcodeModels.length == 0
            ? MyStyle().showProgress()
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  buildShowImage(),
                  SizedBox(
                    height: 4,
                  ),
                  buildTitle(),
                  SizedBox(
                    height: 4,
                  ),
                  buildHeadTable(),
                  buildListView(),
                  buildTotalPrice(),
                  SizedBox(
                    height: 25,
                  ),
                  buildFlatButton(context)
                ],
              ),
      ),
    );
  }

  Row buildFlatButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
            size: 32,
          ),
          label: Text(
            'ยกเลิก',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        FlatButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          color: Colors.orange[700],
          onPressed: () {
            if (total == 0) {
              normalDialog(
                  context, 'ไม่มีรายการสินค้า', 'กรุณาเลือกสินค้าก่อนครับ');
            } else {
              addValueToCart();
            }
          },
          icon: Icon(
            Icons.check,
            color: Colors.white,
            size: 32,
          ),
          label: Text(
            'ยืนยัน',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Row buildTotalPrice() {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'รวมทั้งหมด:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                    fontSize: 32,
                  ),
                ),
              ],
            )),
        Expanded(
            flex: 2,
            child: Container(
              //alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyStyle().myFormat.format(total),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800]),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Container buildHeadTable() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'หน่วย :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'ราคา :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3White('ราคา :')
            ),
            Expanded(
              flex: 1,
              child: Text(
                'จำนวน :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3Whte('จำนวน :')
            ),
            Expanded(
              flex: 1,
              child: Text(
                'ผลรวม :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              // MyStyle().titleH3White('ผลรวม :')
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        // productModel.name,
        products['name'],
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 5,
      ),
    );
  }

  Container buildShowImage() {
    return Container(

        // margin: EdgeInsets.only(top: 16.0, bottom: 16),
        child: CachedNetworkImage(
      // fit: BoxFit.cover,
      width: screen * 0.9,
      height: 300,
      // imageUrl: productModel.urlImage,
      imageUrl: products['urlImage'],
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
          Expanded(
            flex: 1,
            child: Text(
              barcodeModels[index].unit_code,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              MyStyle().myFormat.format(barcodeModels[index].price),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: 32,
                  ),
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
                Text(
                  amounts[index].toString(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 32,
                  ),
                  onPressed: () {
                    // print('You click Add at index ===>> $index');
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
          Expanded(
              flex: 1,
              child: Text(
                MyStyle().myFormat.format(subTotals[index]),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[600],
                ),
              ))
        ],
      ),
    );
  }

  Future<Null> addValueToCart() async {
    int index = 0;
    for (var item in amounts) {
      String code = doct;
      String name = products['name'];

      String barcodes = barcodeModels[index].barcode;
      String prices = barcodeModels[index].price.toString();
      String unitcodes = barcodeModels[index].unit_code;
      int listAmounts = amounts[index];
      String listSubtotals = subTotals[index].toString();
      String urlImage = products['urlImage'];

      print(
          'code = $code, name=$name, barcode= $barcodes, prices=$prices, unitcodes=$unitcodes, listAmount=$listAmounts, listSubtotals=$listSubtotals');

      SQLiteModel model = SQLiteModel(
          code: code,
          name: name,
          barcodes: barcodes,
          prices: prices,
          units: unitcodes,
          amounts: listAmounts,
          subtotals: listSubtotals,
          picturl: urlImage);

      Map<String, dynamic> map = model.toMap();
      await SQLiteHelper().insertValueToSQLite(map);

      index++;
    }
    print('#####index==>>$index');

    Navigator.of(context).pop(true);
    showToast("หยิบสินค้าใส่ตะกร้าแล้วครับ");
  }

  void showToast(String msg) {
    Toast.show(msg, context,
        backgroundColor: Colors.orange[100],
        textColor: Colors.orange[800],
        duration: 3);
  }
}
