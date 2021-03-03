import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ungexercies/widget/product_box.dart';

class MyStyle {
    var myFormat = NumberFormat('#,##0.0#', 'en_US');
    
  Color darkColor = Color(0xff980700);
  Color primartColor = Color(0xffd14500);
  Color lightColor = Color(0xffff7636);

  Widget showProgress() => Center(child: CircularProgressIndicator());

  BoxDecoration boxDecoration() => BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(20),
      );

  ButtonStyle buttonStyle() => ElevatedButton.styleFrom(
        primary: MyStyle().lightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

  Widget showLogo(double width, double height) => ProductItemBox(imageurl: 'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
     width: width, height: height);

  Widget titleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  Widget titleH1Dark(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );

  Widget titleH2(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );

  Widget titleH2dark(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: darkColor,
        ),
      );

  Widget titleH3(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 14,
          color: darkColor,
        ),
      );

  Widget titleH3White(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white54,
        ),
      );

  MyStyle();
}
