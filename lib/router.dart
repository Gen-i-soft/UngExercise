import 'package:flutter/material.dart';
import 'package:ungexercies/states/authen.dart';
import 'package:ungexercies/states/create_account.dart';
import 'package:ungexercies/states/list_catigory.dart';
import 'package:ungexercies/states/my_service.dart';
import 'package:ungexercies/states/show_cart.dart';
import 'package:ungexercies/states/syn_data_to_firebase.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myService': (BuildContext context) => MyService(),
  '/listCatigory': (BuildContext context) => ListCatigory(),
  '/synDataToFirebase': (BuildContext context) => SynDataToFirebase(),
  '/showChart': (BuildContext context) => ShowCart(),
};
