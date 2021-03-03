import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/states/list_product.dart';
import 'package:ungexercies/states/show_cart.dart';
import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/utility/sqlite_helper.dart';
import 'package:ungexercies/widget/show_catigory.dart';
import 'package:ungexercies/widget/show_graphp.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  List<String> titles = ['Catigory', 'Graphyic', 'List Product'];
  int index = 0;
  String nameLogin;
  Widget currentWidget = ShowCatigory();
  int totalItems = 0;
  double total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLogin();
    readCart();
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

  Future<Null> findLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          nameLogin = event.displayName;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Badge(
              badgeColor: Colors.red,
              badgeContent: Text(
                '$totalItems',
                style: TextStyle(color: Colors.white),
              ),
              child:
                  Icon(Icons.shopping_basket_outlined, color: Colors.grey[300]),
            ),
            onPressed: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowCart(onAdItem: ()=>readCart(),),));
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.sync),
          //   onPressed: () => Navigator.pushNamed(context, '/synDataToFirebase'),
          // ),
        ],
        backgroundColor: MyStyle().primartColor,
        title: Text(titles[index]),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccount(),
                buildMenuCatigory(),
                buildMenuGraphic(),
                buildListProduct()
              ],
            ),
            buildSingOut(),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile buildMenuCatigory() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ShowCatigory();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.category,
        color: MyStyle().darkColor,
        size: 36.0,
      ),
      title: MyStyle().titleH2dark(titles[0]),
    );
  }

  ListTile buildMenuGraphic() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ShowGraphic();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.graphic_eq,
        color: MyStyle().darkColor,
        size: 36.0,
      ),
      title: MyStyle().titleH2dark(titles[1]),
    );
  }

  ListTile buildListProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ListProduct(onAdItem: ()=>readCart(),);
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.shopping_basket,
        color: MyStyle().darkColor,
        size: 36.0,
      ),
      title: MyStyle().titleH2dark(titles[2]),
    );
  }

  UserAccountsDrawerHeader buildUserAccount() {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.4,
            center: Alignment(-0.6, 0),
            colors: [Colors.white, MyStyle().darkColor],
          ),
        ),
        currentAccountPicture: MyStyle().showLogo(150,150),
        accountName: MyStyle().titleH1(nameLogin == null ? '' : nameLogin),
        accountEmail: Text('Logined'));
  }

  Column buildSingOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            await Firebase.initializeApp().then((value) async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/authenn', (route) => false));
            });
          },
          tileColor: Colors.red.shade700,
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: MyStyle().titleH2('Sign Out'),
          subtitle: MyStyle().titleH3White('sign Out & Go to Login'),
        ),
      ],
    );
  }
}
