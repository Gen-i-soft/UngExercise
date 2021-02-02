import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/product_cloud_model.dart';

import 'package:ungexercies/states/choose_product.dart';
import 'package:ungexercies/utility/my_style.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  List<ProductCloudModel> productModels = List();
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
          ProductCloudModel model = ProductCloudModel.fromMap(snapshot.data());
          docts.add(snapshot.id);

          setState(() {
            productModels.add(model);
            widgets.add(createWidget(model, index));
          });
          index++;
        }
      });
    });
  }

  Widget createWidget(ProductCloudModel model, int index) => GestureDetector(
        onTap: () {
          print('###################Sentdata url ==>> ${productModels[index].urlImage}');
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseProduct(
                productModel: productModels[index],
                doct: docts[index],
              ),
            ),
          );
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: model.urlImage,
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
