import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/admin/adminhomepage.dart';
import 'package:ungexercies/models/typeusermodel.dart';
import 'package:ungexercies/widget/product_box.dart';


class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isError = false;

  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  Future<Null> signIn() async {
    String email = ctrlEmail.text.trim();
    String password = ctrlPassword.text.trim();
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String uid = value.user.uid;

        await FirebaseFirestore.instance
            .collection('backend')
           .doc(uid)
            .snapshots()
            .listen((event) {
          TypeUserModel model = TypeUserModel.fromMap(event.data());

          switch (model.typeUser) {
            case 'admin':
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHomePage(),
                  ),
                  (route) => false);

              break;
            default:
              print('คุณไม่มีสิทธิ์เข้าใช้งานเมนูนี้ครับ');
          }
        });
      }).catchError((value) {
        print('catchError==>>${value.message}');
      });
    });
  }

  // Future signIn() async {
  //   String email = ctrlEmail.text;
  //   String password = ctrlPassword.text;

  //   try {
  //     AuthResult authResult = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);

  //     if (authResult == null) {
  //       setState(() {
  //         isError = true;
  //       });
  //     } else {
  //       setState(() {
  //         isError = false;
  //       });
  //       print('displayName==>>${authResult.user.displayName}');
  //       print('email==>>${authResult.user.email}');
  //       print('uid==>>${authResult.user.uid}');
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //             builder: (context) => AdminHomePage(),
  //           ),
  //           (route) => false);
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isError = true;
  //     });
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(child: 
                ProductItemBox(imageurl: 'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fwawa.png?alt=media&token=d8e64dbf-f1e3-4c7b-b63f-c60824ee6d4b', 
                width: 80, height: 80),),
                  Text(
                    'ระบบจัดการหลังบ้าน',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'version 1.0.0',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณาระบุอีเมล์';
                      }
                      return null;
                    },
                    controller: ctrlEmail,
                    decoration: InputDecoration(
                        // fillColor: Colors.white,
                        // filled: true,
                        labelText: 'อีเมล์',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                        helperText: 'ระบุอีเมล์เพื่อล็อกอิน',
                        helperStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey[700],
                          size: 32,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณาระบุรหัสผ่าน';
                      }
                      return null;
                    },
                    controller: ctrlPassword,
                    decoration: InputDecoration(
                        // fillColor: Colors.white,
                        // filled: true,
                        labelText: 'รหัสผ่าน',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                        helperText: 'ระบุรหัสผ่านเพื่อล็อกอิน',
                        helperStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300]),
                        prefixIcon: Icon(
                          Icons.lock_open_outlined,
                          size: 32,
                          color: Colors.grey[700],
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isError
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง',
                            style: TextStyle(color: Colors.red, fontSize: 28),
                          ),
                        )
                      : Container(),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.black54,
                    textColor: Colors.black,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //valid
                        signIn();
                      } else {
                        //invalid
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    label: Text(
                      'ลงชื่อเข้าใช้งานระบบ',
                      style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                       fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
