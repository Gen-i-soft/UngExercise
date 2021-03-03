import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/admin/adminchat.dart';
import 'package:ungexercies/admin/adminorder.dart';
import 'package:ungexercies/admin/productmanage.dart';
import 'package:ungexercies/states/authenn.dart';
import 'package:ungexercies/states/create_account.dart';
import 'package:ungexercies/states/sync.dart';
import 'package:ungexercies/states/sync_data_by_category.dart';
import 'package:ungexercies/widget/product_box.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String name;

  int selectedIndex = 0;
  List pages = [AdminOrderPage(), AdminChatPage()];

  Future logout() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Authenn(
                onAdItem: () {},
              ),
            ),
            (route) => false);
      });
    });
  }

  Future checkLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        email = event.email;
        name = event.displayName;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
                width: 60,
                height: 60,
                child: ProductItemBox(
                    imageurl:
                        'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
                    width: 50,
                    height: 50)),
            SizedBox(
              width: 10,
            ),
            Text(
              'จัดการหลังบ้าน',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${name ?? "Demo"}'),
              accountEmail: Text('${email ?? "Demo@demo.com"}'),


              currentAccountPicture: Container(
                child: ProductItemBox(
                    imageurl:
                        'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b',
                    width: 60,
                    height: 60),
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.folder_open, color: Colors.blue[700]),
              title: Text(
                'ข้อมูลสินค้า',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => ProductManage(),
                // ));
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.blue[700]),
              title: Text(
                'หมวดหมู่สินค้า',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.blue[700]),
              title: Text(
                'ข้อมูลร้าน',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
            ),
                 ListTile(onTap: () {
                     Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SyncDataCentre(),
                        ));
                 
                   
                 },
              leading: Icon(Icons.home, color: Colors.blue[700]),
              title: Text(
                'Sync Data',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
            ),

            ListTile(
              onTap: () {
                     Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateAccount(),
                        ));
                 
                   
                 },
              leading: Icon(Icons.supervised_user_circle, color: Colors.blue[700]),
              title: Text(
                'ลงทะเบียนลูกค้าใหม่',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
            ),
            //      ListTile(onTap: () {
            //            Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => SyncDataByCategory(),
            //             ));
                 
                   
            //      },
            //   leading: Icon(Icons.home, color: Colors.blue[700]),
            //   title: Text(
            //     'Sync Data บางส่วน',
            //     style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.blue[700]),
            //   ),
            //   trailing: Icon(Icons.arrow_right, color: Colors.blue[200]),
            // )




           
          ],
        ),
      ),
      body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black45,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text('ออร์เดอร์สินค้า')),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), title: Text('ข้อความลูกค้า')),
            // BottomNavigationBarItem(
            // icon: Icon(Icons.call), title: Text('ลูกค้าเรียก')),
          ])
    
    );

    }

}
  

