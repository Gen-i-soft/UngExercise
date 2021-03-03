import 'package:badges/badges.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/admin/admin_login.dart';
import 'package:ungexercies/states/chat_page.dart';

import 'package:ungexercies/states/payment_page.dart';
import 'package:ungexercies/states/product_page.dart';
import 'package:ungexercies/states/promotion.dart';

import 'package:ungexercies/states/searchvtwo.dart';
import 'package:ungexercies/states/show_cart.dart';

import 'package:ungexercies/utility/helper.dart';

import 'package:ungexercies/utility/sqlite_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //params
  Helper helper = new Helper();
  int selectedIndex = 0;
  double total = 0;
  int totalItems = 0;
  String nameLogin;

  Future<Null> findLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          nameLogin = event.displayName;
        });
      });
    });
  }

  
  Future<Null> readCart() async {
    print('##############>>>>readCart work ');
    try {
      await SQLiteHelper().readSQLite().then((value) {
        int index = 0;
        for (var string in value) {
          String sumString = string.subtotals;
          double sumDouble = double.parse(sumString);
          setState(() {
            total = total + sumDouble;
          });
          index++;
        }

        setState(() {
          totalItems = index;
        });
      });
    } catch (e) {
      print('########### status in SQLite ===>>> ${e.toString()}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLogin();
    readCart();

    // mapLineLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
              width: 32,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'WAWA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 6,
            )
          ],
        ),
        actions: [  
          //  IconButton(
          //   icon: Icon(Icons.print),
          //   onPressed: () {
          //     // Navigator.push(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //       builder: (context) => PrinterPage(),
          //     //     ));
          //   },
          // ),
          // SizedBox(
          //   width: 5,
          // ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SearchVersionTwo(onAdItem: () => readCart()),
              ));
            },
            child: Row(
              children: [
                Icon(Icons.search),
                Text(
                  'ค้นหา',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          IconButton(
            icon: Icon(Icons.campaign),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Promotion(onAdItem: () => readCart()),
                  ));
            },
          ),
          SizedBox(
            width: 5,
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdminLoginPage(),
              ));
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.exit_to_app),
          //   onPressed: () {
              
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => SynDataToFirebase(),
          //     ));
          //   },
          // ),
        ],
      ),

      // List pages = [
      //   ProductPage(),
      //   ShowCart(

      //   ),
      //   ChatPage(),
      //   PaymentPage()
      // ];
      body: selectedIndex == 0
          ? ProductPage(onAdItem: () => readCart())
          : selectedIndex == 1
              ? ShowCart(onAdItem: () => readCart())
              : selectedIndex == 2
                  ? ChatPage()
                  : PaymentPage(),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xffB7B7B7),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xff000000),
          unselectedItemColor: Color(0xff7C7C7C),
          showSelectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('สั่งสินค้า'),
            ),
            BottomNavigationBarItem(
              title: Text('ตะกร้าสินค้า'),
//0
              icon: Badge(
                shape: BadgeShape.circle,
                borderRadius: BorderRadius.circular(100),
                child: Icon(Icons.shopping_basket),
                badgeContent: Text(
                  '$totalItems',
                  style: TextStyle(color: Colors.white),
                ),
              ),

//1
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('ติดต่อพนักงาน'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text('โปรไฟล์'),
            ),
          ]),
    );
  }
}
