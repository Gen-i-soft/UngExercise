import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:ungexercies/states/choose_product.dart';


import 'package:ungexercies/utility/my_style.dart';

import 'package:ungexercies/widget/product_box.dart';

class BestSellerWidget extends StatefulWidget {
  final Function onAdItem;
  BestSellerWidget({@required this.onAdItem});
  @override
  _BestSellerWidgetState createState() => _BestSellerWidgetState();
}

class _BestSellerWidgetState extends State<BestSellerWidget> {
  // params
  // final dbRef = Firestore.instance;
  // List<ProductCloudModel> productModels = List();

  List<Widget> widgets = List();
  List<String> docts = List();
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  List<DocumentSnapshot> products = [];

  // List<DocumentSnapshot> promotions = [];
  bool loading = false;
  double sizeWidth;

  //Method

//แบบเผื่อเรียก
  Future getPromotion() async {
    // setState(() {
    //   loading = true;
    // });
    // await Firebase.initializeApp().then((value) async {
    //   QuerySnapshot snapshot = await FirebaseFirestore.instance
    //       .collection('product')
    //       .where('urlImage', isNotEqualTo: '')
    //       .limit(20)
    //       .get();

    //   setState(() {
    //     products = snapshot.docs;
    //   });

    // await FirebaseFirestore.instance
    //     .collection('product')

    //     .snapshots()
    //     .listen((event) {
    //   loading = false;
    //   int index = 0;
    //   for (var snapshot in event.docs) {
    //     ProductCloudModel model = ProductCloudModel.fromMap(snapshot.data());
    //     docts.add(snapshot.id);
    //     // print('id===>>${snapshot.id}');
    //     setState(() {
    //       productModels.add(model);
    //       widgets.add(createWidget(model, index));
    //     });
    //     index++;
    //   }
    // });
    // });

    // QuerySnapshot snapshot = await dbRef
    //     .collection('WawaDB')
    //     .document('yeRSeBlZRuU9xg0p2CrO')
    //     .collection('products')
    //     .where('isPromotion',isEqualTo: true)
    //     .getDocuments();

    // setState(() {
    //   promotions = snapshot.documents;
    //   loading = false;
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPromotion();
    //lazy load controll ด้วย scroller

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        amountListView = amountListView + 2;
      }
    });
  }

  // Widget createWidget(DocumentSnapshot products, int index) => GestureDetector(
  //     onTap: () async {
  //       var res = await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ChooseProduct(
  //             onAdItem: () => widget.onAdItem(),
  //             products: products,
  //             // doct: docts[index],
  //           ),
  //         ),
  //       );
  //       if (res != null) {
  //         widget.onAdItem();
  //       }
  //     },
  //     child: Container(
  //       width: 120,
  //       height: 120,
  //       child: Column(
  //         children: [
  //           Stack(
  //             children: [
  //               ProductItemBox(
  //                 imageurl: products['urlImage'],
  //                 width: 90,
  //                 height: 90,
  //               ),
  //               Container(
  //                   margin: EdgeInsets.all(5),
  //                   // alignment: Alignment.center,
  //                   width: 50,
  //                   height: 20,
  //                   decoration: BoxDecoration(
  //                       color: Colors.pink[100],
  //                       borderRadius: BorderRadius.circular(10)),
  //                   child: Center(
  //                       child: Text(
  //                     'ขายดี',
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                         color: Colors.red[600]),
  //                   ))),
  //             ],
  //           ),
  //           Text(
  //             products[index].name,
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //             softWrap: false,
  //             style: TextStyle(fontSize: 18),
  //           )
  //         ],
  //       ),
  //     )

  //     // Card(
  //     //   child: Column(
  //     //     mainAxisAlignment: MainAxisAlignment.center,
  //     //     children: [
  //     //       Container(
  //     //         width: 100,
  //     //         height: 100,

  //     //         child: CachedNetworkImage(
  //     //           fit: BoxFit.cover,
  //     //           imageUrl: model.urlImage,
  //     //           errorWidget: (context, url, error) =>
  //     //               Image.asset('images/image.png'),
  //     //           placeholder: (context, url) => MyStyle().showProgress(),
  //     //         ),
  //     //       ),
  //     //       Container(width: sizeWidth * 0.5 - 16, child: Text(model.name,
  //     //       overflow: TextOverflow.ellipsis,softWrap: false,maxLines: 2,
  //     //       style: TextStyle(fontSize: 24, ),))
  //     //     ],
  //     //   ),
  //     // ),
  //     );

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loading
              ? LinearProgressIndicator(
                  backgroundColor: Colors.pink.shade100,
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              'สินค้าขายดี',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('product')
                    .where('urlImage', isNotEqualTo: '')
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return MyStyle().showProgress();

                      break;
                    default:
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      GestureDetector(onTap: () {
                                         Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChooseProduct(products: document, onAdItem:  () => widget.onAdItem(),),
                      ));
                                      },
                                                                              child: ProductItemBox(
                                            imageurl: document['urlImage'],
                                            width: 100,
                                            height: 70),
                                      ),
                                      Container(
                                        child: Text(
                                          'ขายดี',
                                          style: TextStyle(color: Colors.pink),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.pink[50],
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }).toList(),
                          )
                        ],
                      );
                  }
                }),
          ))
          // Expanded(
          //   child: ListView(
          //       controller: scrollController,
          //       scrollDirection: Axis.horizontal,
          //       children: widgets

          //     [
          //       Wrap(
          //         spacing: 8,
          //         runSpacing: 8,
          //         children: productModels.map((item ) {
          //           return Column(
          //             children: [
          //               GestureDetector(

          //                 onTap: ()async{

          //                        var res = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context ) => ChooseProduct(
          //       onAdItem: () => widget.onAdItem(),
          //       productModel: productModels[index],
          //       doct: docts[index],
          //     ),
          //   ),
          // );
          // if (res != null) {
          //   widget.onAdItem();
          // }

          //                 },
          //                                         child: Stack(
          //                   children: [
          //                     ProductItemBox(
          //                       imageurl: item.urlImage,
          //                       width: 100,
          //                       height: 70,
          //                     ),
          //                     Container(
          //                         margin: EdgeInsets.all(5),
          //                         // alignment: Alignment.center,
          //                         width: 50,
          //                         height: 20,
          //                         decoration: BoxDecoration(
          //                             color: Colors.pink[100],
          //                             borderRadius: BorderRadius.circular(10)),
          //                         child: Center(
          //                             child: Text(
          //                           'ขายดี',
          //                           style: TextStyle(
          //                               fontSize: 16,
          //                               fontWeight: FontWeight.w600,
          //                               color: Colors.red[600]),
          //                         ))),
          //                   ],
          //                 ),
          //               ),
          //               Text(
          //                 item.name,
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 softWrap: false,
          //                 style: TextStyle(fontSize: 24),
          //               )
          //             ],
          //           );
          //         }).toList(),
          //       )
          //     ],

          // ),
          // )
        ]);
  }
}
