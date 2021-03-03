import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/product_cloud_model.dart';
import 'package:ungexercies/models/product_model.dart';
import 'package:ungexercies/utility/debouncer.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductCloudModel> productModels = [];
  List<ProductCloudModel> filterProductModels = [];
  final debouncer = Debouncer(milliseconds: 500);
  //Method
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหารายการสินค้า'),
      ),
      body: Column(
        children: [searchText(), showListView()],
      ),
    );
  }

  Widget searchText() {
    return TextField(
      decoration: InputDecoration(hintText: 'ค้นหารายการสินค้า'),
      onChanged: (value) {
        debouncer.run(() {
          filterProductModels = productModels
              .where(
                  (u) => (u.name.toLowerCase().contains(value.toLowerCase())))
              .toList();
        });
      },
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: filterProductModels.length,
        itemBuilder: (context, index) {
          return Text(filterProductModels[index].name);
        },
      ),
    );
  }

  Future<void> readAllData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          .snapshots()
          .listen((event) {
        // loading = false;

        for (var snapshot in event.docs) {
          ProductCloudModel model = ProductCloudModel.fromMap(snapshot.data());
          // docts.add(snapshot.id);
          // print('id===>>${snapshot.id}');
          setState(() {
            productModels.add(model);
            filterProductModels = productModels;
          });
        }
      });
    });
  }
}
