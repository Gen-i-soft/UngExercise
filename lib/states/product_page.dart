import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/widget/best_seller.dart';

import 'package:ungexercies/widget/category_widget.dart';
import 'package:ungexercies/widget/product_list_widget.dart';

class ProductPage extends StatefulWidget {
  final Function onAdItem;
  ProductPage({@required this.onAdItem});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double screen;
  double screen2;
  String categoryId;

  double sizeWidth;
  int totalItems = 0;
  double total = 0;
  ScrollController scrollController = ScrollController();
  int amountListView = 6;
  List<Widget> widgets = List();

  bool loading = false;
  List<DocumentSnapshot> products = [];
  

  Future<Null> getProduct() async {
    setState(() {
      loading = true;
    });
    await Firebase.initializeApp().then((value) async {
       if (categoryId == null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('product')
          .where('urlImage', isNotEqualTo: '')
          .limit(200)
         
          .get();
      setState(() {
        loading = false;
        products = snapshot.docs;
      });
      print('i am null');
      } else {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('product')
            .where('urlImage', isNotEqualTo: '')
            .where('categoryName', isEqualTo: categoryId)
            .get();
        setState(() {
          loading = false;
          products = snapshot.docs;
        });

        print('i am not null');
      }

      print('products==>>$products');

      // try {
      //   await FirebaseFirestore.instance
      //       .collection('product')
      //       .where('urlImage', isNotEqualTo: '')
      //       .snapshots()
      //       .listen((event) async {
      //     int index = 0;
      //     for (var snapshot in event.docs) {
      //       ProductCloudModel model =
      //           ProductCloudModel.fromMap(snapshot.data());
      //       docts.add(snapshot.id);

      //       setState(() {
      //         productModels.add(model);
      //         widgets.add(createWidget(model, index));
      //       });
      //       index++;
      //     }
      //   });
      // } catch (e) {
      //   print('e>>>${e.toString()}');
      // }
    });
  }

  // Widget createWidget(DocumentSnapshot products) => GestureDetector(
  //       onTap: () async {
  //         print('###################Sentdata url ==>> ${products['urlImage']}');
  //         var res = await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ChooseProduct(
  //               onAdItem: () => widget.onAdItem(),
  //               products: products,
  //               // productModel: products,
  //               // doct: docts[index],
  //             ),
  //           ),
  //         );
  //         if (res != null) {
  //           widget.onAdItem();
  //         }
  //       },
  //       child: Card(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: screen * .4,
  //               height: 120,
  //               child: CachedNetworkImage(
  //                 // fit: BoxFit.cover,
  //                 imageUrl: products['urlImage'],
  //                 errorWidget: (context, url, error) =>
  //                     Image.asset('images/image.png'),
  //                 placeholder: (context, url) => MyStyle().showProgress(),
  //               ),
  //             ),
  //             Container(
  //                 width: sizeWidth * 0.5 - 16,
  //                 child: Text(
  //                   products['name'],
  //                   overflow: TextOverflow.ellipsis,
  //                   softWrap: false,
  //                   maxLines: 2,
  //                   style: TextStyle(
  //                     fontSize: 24,
  //                   ),
  //                 ))
  //           ],
  //         ),
  //       ),
  //     );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        amountListView = amountListView + 4;
      }
    });
  }

  // ListView buildListView() {
  //   return ListView.builder(
  //     controller: scrollController,
  //     itemCount: products.length,
  //     itemBuilder: (context, index) => Card(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: MyStyle().titleH2dark(products[index]['name']),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    screen2 = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Color(0xffCBC5C0),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 5, left: 10),
            child: BestSellerWidget(onAdItem: () => widget.onAdItem()),
            height: 130,
            color: Colors.white,
          ),
          Container(
            // margin: EdgeInsets.only(top: 2),
            child: CategoryWidget(
              onChange: (DocumentSnapshot document) {
                print('onchange=>>>${document['itemcode']}');
                setState(() {
                   categoryId = document['name'];
                  // พอตัวนี้เปลี่ยนมันจะไปบังคับให้ตัวอื่นเปลี่ยนตาม
                });
                getProduct();

                // print('document>>>${document['name']}');
              },
            ),
            height: 90,
            color: Colors.white,
          ),

          // Container(
          //   alignment: Alignment.topLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: Row(
          //       children: [

          //         Text(
          //           'รายการสินค้าในหมวดหมู่',
          //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //         ),
          //         SizedBox(width: 10),
          //         Container(
          //           padding: EdgeInsets.only(left: 5, right: 5),
          //           width: 120,
          //           height: 40,
          //           decoration: BoxDecoration(
          //               color: Colors.orange[200],
          //               borderRadius: BorderRadius.circular(10)),
          //           child: GestureDetector(
          //             onTap: () {
          //               Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (context) => SearchVersionTwo(
          //                     onAdItem: () => widget.onAdItem()),
          //               ));
          //             },
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Icon(
          //                   Icons.search,
          //                   size: 28,
          //                   color: Colors.orange[900],
          //                 ),
          //                 Text('ค้นหา',
          //                     style: TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         color: Colors.orange[800],
          //                         fontSize: 28)),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Text('5 รายการ')

          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 5),
                child: ProductListWidget(onAdItem: ()=>widget.onAdItem(),
                  products: products,
                )),
          ),

// Expanded(child: Responsive)

          // Expanded(
          //   child: GridView.extent(
          //     maxCrossAxisExtent: 300,
          //     children: widgets,
          //   ),
          // ),
          // Expanded(
          //     child: Container(
          //   margin: EdgeInsets.only(top: 3),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Expanded(child: ListProduct(categoryId: categoryId,onAdItem: () => widget.onAdItem())),
          //     ],
          //   ),
          //   color: Colors.white,
          // )),
        ],
      ),
    );
  }
}
