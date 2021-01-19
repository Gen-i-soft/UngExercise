import 'package:flutter/material.dart';

class MyStyle {
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

  Widget showLogo() => Image.asset('images/logo.png');

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
