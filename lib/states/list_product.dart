import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/barcode_model.dart';
import 'package:ungexercies/models/product_model.dart';
import 'package:ungexercies/states/choose_product.dart';
import 'package:ungexercies/utility/my_style.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  List<ProductModel> productModels = List();
  List<Widget> widgets = List();
  List<String> docts = List();
  double sizeWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProduct();
  }

  Future<Null> readProduct() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          .snapshots()
          .listen((event) async {
        int index = 0;
        for (var snapshot in event.docs) {
          ProductModel model = ProductModel.fromJson(snapshot.data());
          docts.add(snapshot.id);

          setState(() {
            productModels.add(model);
            widgets.add(createWidget(model, 'urlImage', index));
          });
          index++;
        }
      });
    });
  }

  Widget createWidget(ProductModel model, String urlImage, int index) =>
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseProduct(
              productModel: productModels[index],
              doct: docts[index],

            ),
          ),
        ),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/lekexecise.appspot.com/o/image%2F03-0076.jpg?alt=media&token=f1b9bdc2-49d1-4baf-b736-4f157f4bbb79',
                  errorWidget: (context, url, error) =>
                      Image.asset('images/image.png'),
                  placeholder: (context, url) => MyStyle().showProgress(),
                ),
              ),
              Container(width: sizeWidth * 0.5 - 16, child: Text(model.name))
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: widgets.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: sizeWidth * 0.5 + 64,
              children: widgets,
            ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyStyle().titleH2dark(productModels[index].name),
        ),
      ),
    );
  }
}
