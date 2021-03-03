import 'package:flutter/material.dart';
import 'package:ungexercies/states/authen.dart';
import 'package:ungexercies/states/authenn.dart';
import 'package:ungexercies/states/create_account.dart';
import 'package:ungexercies/states/home.dart';
import 'package:ungexercies/states/list_catigory.dart';
import 'package:ungexercies/states/my_service.dart';
import 'package:ungexercies/states/show_cart.dart';
import 'package:ungexercies/states/syn_data_to_firebase.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/authenn': (BuildContext context) => Authenn(onAdItem: (){},),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myService': (BuildContext context) => MyService(),
  '/listCatigory': (BuildContext context) => ListCatigory(),
  '/synDataToFirebase': (BuildContext context) => SynDataToFirebase(),
  '/showChart': (BuildContext context) => ShowCart(onAdItem: (){},),
  '/homePage': (BuildContext context) => HomePage(),
};
