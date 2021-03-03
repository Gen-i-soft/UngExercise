import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:ungexercies/states/choose_product.dart';
import 'package:ungexercies/widget/product_box.dart';

class ProductListWidget extends StatefulWidget {
   final Function onAdItem;
  final List<DocumentSnapshot> products;
  ProductListWidget({@required this.products,@required this.onAdItem});
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  double screen;
  double screen2;
  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    screen2 = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รายการในหมวดหมู่',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(height: 30,
              margin: EdgeInsets.only(bottom: 5),
             
                child: Chip(
                  padding: EdgeInsets.only(bottom: 5),
                  label: Text(
                    '${widget.products.length} รายการ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  backgroundColor: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ResponsiveGridList(
            desiredItemWidth: 160,
            minSpacing: 5,
            children: widget.products.map((DocumentSnapshot product) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChooseProduct(products: product, onAdItem:  () => widget.onAdItem(),),
                      ));
                    },
                    child: ProductItemBox(
                        imageurl: '${product['urlImage']}',
                        width: screen * 0.6,
                        height: 150),
                  ),
                  // SizedBox(height: 10,),
                  Text(
                    '${product['name']}',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 3,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
