import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/states/choose_product.dart';
import 'package:ungexercies/utility/debouncer.dart';
import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/widget/product_box.dart';

class SearchVersionTwo extends StatefulWidget {
  final Function onAdItem;
  SearchVersionTwo({@required this.onAdItem});
  @override
  _SearchVersionTwoState createState() => _SearchVersionTwoState();
}

class _SearchVersionTwoState extends State<SearchVersionTwo> {
  TextEditingController _myCtrl = TextEditingController();
  // List<ProductCloudModel> productModels = List();
  List<String> docts = List();
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  double screen;

  String searchtxt;
  bool loading = false;
  final debouncer = Debouncer(milliseconds: 1000);
  List<DocumentSnapshot> products = [];

  Future<Null> readProduct() async {
    await Firebase.initializeApp().then((value) async {
      try {
       QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('product')
             .where('name', isGreaterThanOrEqualTo: searchtxt)
             .limit(10)
            
             
               .orderBy('name', descending: false)

            .get();
          //   .then((value) async {
          // int _index = 0;

          // for (var item in value.docs) {
          //   Map<String, dynamic> mapName = Map();
          //   mapName['name'] = item['name'];
          //   mapName['urlImage'] = item['urlImage'];
          //   mapName['categoryName'] = item['category'];
          //   mapName['itemCategory'] = item['itemCategory'];

          //   await Firebase.initializeApp().then((value) async {
          //     await FirebaseFirestore.instance
          //         .collection('productsearch')
          //         .doc()
          //         .set(mapName);
          //   });
          // }
       

        setState(() {
          loading = false;
          products = snapshot.docs;
        });

        // await FirebaseFirestore.instance
        //     .collection('product')
        //     // .where('name', isGreaterThanOrEqualTo: searchtxt)
        //     .where('name', isGreaterThanOrEqualTo: searchtxt)
        //     .where('urlImage', isNotEqualTo: '')
        //     .orderBy('name', descending: false)
        //     .limit(20)
        //     .snapshots()
        //     .listen((event) async {
        //   int index = 0;
        //   for (var snapshot in event.docs) {
        //     ProductCloudModel model =
        //         ProductCloudModel.fromMap(snapshot.data());
        //     docts.add(snapshot.id);

        //     productModels.add(model);
        //     print('model==>>${model.name}');
        //   }
        //   setState(() {
        //     loading = false;
        //   });
        //   print('model==>>${productModels.length}');
        //   print('search==>>$searchtxt');
        // });
      } catch (e) {
        print('e OrderBy==>${e.toString()}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProduct();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        amountListView = amountListView + 4;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ค้นหารายการสินค้า',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   color: Colors.orange[200]
                  // ),
                  width: screen * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _myCtrl,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.orange[200]),
                      onChanged: (text) {
                        // print('value==>>$text');
                        setState(() {
                          searchtxt = text;
                        });
                        debouncer.run(() {
                          readProduct();
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 36,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    readProduct();
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 36,
                    color: Colors.red[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _myCtrl.clear();
                    });
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                
              ],
            ),

            // Expanded(
            //     child: Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: StreamBuilder<QuerySnapshot>(
            //       stream: FirebaseFirestore.instance
            //           .collection('product')
            //           // .where('urlImage', isNotEqualTo: '')
            //           .where('name', isGreaterThanOrEqualTo: searchtxt)
            //           .where('urlImage', isNotEqualTo: '')
            //           // .orderBy('name', descending: false)
            //           .limit(20)
            //           .snapshots(),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasError) {
            //           print(snapshot.hasError);
            //           return new Text('Error: ${snapshot.error}');
            //         }
            //         switch (snapshot.connectionState) {
            //           case ConnectionState.waiting:
            //             return MyStyle().showProgress();

            //             break;
            //           default:
            //             return ListView(
            //               scrollDirection: Axis.vertical,
            //               children: [
            //                 Wrap(
            //                   spacing: 8,
            //                   runSpacing: 8,
            //                   children: snapshot.data.docs
            //                       .map((DocumentSnapshot document) {
            //                     return Column(
            //                       children: [

            // Stack(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         Navigator.of(context)
            //             .push(MaterialPageRoute(
            //           builder: (context) =>
            //               ChooseProduct(
            //             products: document,
            //             onAdItem: () =>
            //                 widget.onAdItem(),
            //           ),
            //         ));
            //       },
            //       child: ProductItemBox(
            //           imageurl: document['urlImage'],
            //           width: 100,
            //           height: 70),
            //     ),
            //     Container(
            //       child: Text(
            //         'ขายดี',
            //         style:
            //             TextStyle(color: Colors.pink),
            //       ),
            //       decoration: BoxDecoration(
            //           color: Colors.pink[50],
            //           borderRadius:
            //               BorderRadius.circular(5)),
            //     ),
            //   ],
            // )
            //                       ],
            //                     );
            //                   }).toList(),
            //                 )
            //               ],
            //             );
            //         }
            //       }),
            // ))

            // Expanded(child: null)
            Expanded(
                child: loading
                    ? MyStyle().showProgress()
                    : ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: ListTile(
                                onTap: () async {
                                  var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChooseProduct(
                                        onAdItem: () => widget.onAdItem(),
                                        products: products[index],
                                      ),
                                    ),
                                  );
                                  if (res != null) {
                                    widget.onAdItem();
                                  }
                                },
                                leading: ProductItemBox(
                                    imageurl: products[index]['urlImage'],
                                    width: 60,
                                    height: 60),
                                title: Text(
                                  '${products[index]['name']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                trailing: Icon(
                                  Icons.arrow_right,
                                  size: 24,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }
}
