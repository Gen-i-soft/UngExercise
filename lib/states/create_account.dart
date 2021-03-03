import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/utility/dialog.dart';
import 'package:ungexercies/utility/helper.dart';
import 'package:ungexercies/utility/my_style.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  double screen;
  String name, user, password;
  Helper helper = new Helper();

  Container buildName() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 64),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          labelText: 'ชื่อสกุล',
          prefixIcon: Icon(
            Icons.fingerprint,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          // hintStyle: TextStyle(color: MyStyle().darkColor),
          // hintText: 'อีเมล์ :',
          labelText: 'อีเมล์',
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),

          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'รหัสผ่าน',
          labelStyle: TextStyle(
              fontSize: 20,
              color: Color(0xff980700),
              fontWeight: FontWeight.bold),
          prefixIcon: Icon(
            Icons.lock_open_outlined,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      //  resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: false,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x66976997),
                Color(0x99976997),
                Color(0xcc976997),
                Color(0xff976997)
              ]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: MyStyle().showLogo(150, 150),
                ),
                buildName(),
                buildUser(),
                buildPassword(),
                buildCreateAccount(),
                SizedBox(
                  height: 30,
                ),
                // buildGotoLogin()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCreateAccount() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff1E6B85),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        //
        onPressed: () {
          if ((name?.isEmpty ?? true) ||
              (user?.isEmpty ?? true) ||
              (password?.isEmpty ?? true)) {
            normalDialog(
                context, 'มีช่องว่าง', 'กรุณากรอกข้อมูลให้ครบทุกช่องครับ');
          } else {
            registerThread();
          }
        },
        child: Text(
          'สร้างบัญชีใหม่',
          style: TextStyle(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildGotoLogin() {
    return GestureDetector(
      onTap: () {
        //  Navigator.pushNamed(context, '/authenn');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ลงชื่อเข้าใช้งาน',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Future<Null> registerThread() async {
    await Firebase.initializeApp().then((value) async {
      // normalDialog(context, "Initial Success", 'Good');

      print('initialize Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: password)
          .then((value) {
        Navigator.of(context).pop();
      });

      //     .then((value) async {
      //   String _pictureUrl = value.user.photoURL;
      //   String _uid = value.user.uid;
      //   String _displayName = value.user.displayName;

      //   helper.setStorage('lineUserID', '');
      //   helper.setStorage('displayName', _displayName);

      //   helper.setStorage('pictureUrl', _pictureUrl);
      //   helper.setStorage('uid', _uid); //ทุกอย่างจะผูกกับ ฟิลด์นี้หมดเลยจ้า

      //   await value.user.updateProfile(displayName: name).then((value) {
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, '/homePage', (route) => false);
      //   });
      // }).catchError((value) {
      //   normalDialog(context, value.code, value.message);
      // });
    }).catchError((value) {
      print('error initial => ${value.message}');
    });
  }
}
