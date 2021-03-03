import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:ungexercies/models/linemodel.dart';
import 'package:ungexercies/states/syn_data_to_firebase.dart';
import 'package:ungexercies/states/sync.dart';

import 'package:ungexercies/utility/dialog.dart';
import 'package:ungexercies/utility/helper.dart';
import 'package:ungexercies/utility/my_style.dart';

class Authenn extends StatefulWidget {
  final Function onAdItem;
  Authenn({@required this.onAdItem});
  @override
  _AuthennState createState() => _AuthennState();
}

class _AuthennState extends State<Authenn> {
  double screen;
  String user, password;
  bool statusRedEye = true;
  Map<String, dynamic> datas;
  UserCredential userCredential;
  List<LineLoginModel> models = List();
  Helper helper = new Helper();

  get userID => null;

  void showToast(String msg) {
    Toast.show(msg, context,
        backgroundColor: Colors.orange[100],
        textColor: Colors.orange[800],
        duration: 3);
  }

  // void _onLoginSuccess(Object data) async {
  //   var myMap = Map<String, dynamic>.from(data);
  //   // print("myMap==>${myMap['userID']}");
  //   //userID line
  //   String userID = myMap['userID'];
  //   String displayName = myMap['displayName'];
  //   String pictureUrl = myMap['pictureUrl'];

  //   helper.setStorage('lineUserID', userID);
  //   helper.setStorage('displayName', displayName);
  //   helper.setStorage('pictureUrl', pictureUrl);

  //   print('userId==>>$userID');
  //   print('displayName==>>$displayName');
  //   print('pictureUrl==>>$pictureUrl');
  //   // String lineUser = await helper.getStorage('lineUserID');

  //   // print('get_lineUserID###>>$lineUser');

  //   await Firebase.initializeApp().then((value) async {
  //     await FirebaseFirestore.instance
  //         .collection('linelogin')
  //         //check ว่ามีมั้ย
  //         .where('lineid', isEqualTo: userID)
  //         .snapshots()
  //         .listen((event) {
  //       if (event.docs.length != 0) {
  //         print('you passed this event.docs.length != 0### ');
  //         for (var item in event.docs) {
  //           LineLoginModel model = LineLoginModel.fromMap(item.data());

  //           models.add(model);

  //         }
  //           //ได้ uid ของfirebase;
  //           helper.setStorage('uid', models[0].uid);

  //           Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(
  //                 builder: (context) => HomePage(),
  //               ),
  //               (route) => false);
  //       } else {
  //         //ไม่มีจ้า

  //       Firebase.initializeApp().then((value) async {
  //           await FirebaseAuth.instance
  //               .signInAnonymously()
  //               .then((valuee) async {
  //             helper.setStorage('uid', valuee.user.uid);
  //             // String _uid = await helper.getStorage('uid');

  //             String lineUser = await helper.getStorage('lineUserID');
  //             String uid = await helper.getStorage('uid');
  //             String displayName = await helper.getStorage('displayName');
  //             String pictureUrl = await helper.getStorage('pictureUrl');
  //             if (lineUser != null) {
  //               await Firebase.initializeApp().then((value) async {
  //                 print('value_value==>>$value');

  //                 await FirebaseFirestore.instance.collection('linelogin').add({
  //                   "uid": uid,
  //                   "lineid": lineUser,
  //                   "displayname": displayName,
  //                   "picturl": pictureUrl,
  //                 });
  //               });
  //             }

  //             print('mapLineLogined...');

  //             // print('get_uid###>>$_uid');

  //             Navigator.of(context).pushAndRemoveUntil(
  //                 MaterialPageRoute(
  //                   builder: (context) => HomePage(),
  //                 ),
  //                 (route) => false);
  //             //  print('uid==>>${valuee.user.uid}');
  //             print('you passed this signInAnonymously not!= 0### ');
  //           });
  //         });
  //       } //else
  //     });
  //   });
  // } //onsuccess

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: false,
      // floatingActionButton: buildCreateAccount(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x66D2C6C6),
                Color(0x99D2C6C6),
                Color(0xccD2C6C6),
                Color(0xffD2C6C6)
              ]),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildLogo(),
                  buildUser(),
                  buildPassword(),
                  buildLogin(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '-OR-',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                 
                  // buildLoginWiteLine(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildCreateAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Account?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createAccount');
            },
            child: Text(
              'สมัครสมาชิกใหม่',
              style: TextStyle(
                  fontSize: 22,
                  color: Color(0xff71501C),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );

  Container buildUser() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => user = value.trim(),
        style: TextStyle(color: Colors.black, fontSize: 28),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.black38),
          hintText: 'อีเมล์ :',
          prefixIcon: Icon(
            Icons.email,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black45),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      // color: Colors.white,
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        obscureText: statusRedEye,
        onChanged: (value) => password = value.trim(),
        style: TextStyle(color: Colors.black, fontSize: 28),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.black38),
          hintText: 'รหัสผ่าน :',
          prefixIcon: Icon(
            Icons.vpn_key,
          ),
          suffixIcon: IconButton(
              icon: Icon(statusRedEye
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined),
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
              }),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black45),
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return MyStyle().showLogo(150, 150);
  }

  // Widget buildLoginWiteLine() {
  //   return GestureDetector(
  //     onTap: () {
  //       _startLogin();
  //     },
  //         child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         color: Colors.green[600]

  //       ),
  //       height: 60,
  //       margin: EdgeInsets.only(top: 16),
  //       width: screen * 0.7,
  //       child: Row(mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //         ProductItemBox(imageurl: 'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fline.png?alt=media&token=b2faca8f-9842-490e-a53b-7ad34cd4b89f',
  //          width: 50, height: 50),SizedBox(width: 5,),
  //          Text('ลงทะเบียนผ่านไลน์ ',
  //              style: TextStyle(
  //               fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),)
  //       ],)

  //       // ElevatedButton(
  //       //   style: ElevatedButton.styleFrom(
  //       //     primary: Color(0xff45F034),
  //       //     shape:
  //       //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       //   ),
  //         // onPressed: () {
  //         //   _startLogin();
  //         // },
  //       //   child: Text(
  //       //     'เข้าใช้งานผ่านระบบไลน์',

  //       //   ),
  //       // ),
  //     ),
  //   );
  // }

  Container buildLogin() {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xffA97474),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(
                context, 'พบข้อผิดพลาด', 'กรุณากรอกข้อมูลให้ครบทุกช่องครับ');
          } else {
            checkAuthen();
          }
        },
        child: Text(
          'ลงชื่อเข้าใช้งาน',
          style: TextStyle(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: password)
          .then((value) {
        String _displayName = value.user.displayName;
        String _pictureUrl = value.user.photoURL;
        String _uid = value.user.uid;
        helper.setStorage('lineUserID', '');
        helper.setStorage('displayName', _displayName);
        helper.setStorage('pictureUrl', _pictureUrl);
        helper.setStorage('uid', _uid); //ทุกอย่างจะผูกกับ ฟิลด์นี้หมดเลยจ้า

        Navigator.pushNamedAndRemoveUntil(
            context, '/homePage', (route) => false);
      }).catchError(
              (value) => normalDialog(context, value.code, value.message));
    });
  }
}
