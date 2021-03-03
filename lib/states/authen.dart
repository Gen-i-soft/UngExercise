import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/utility/dialog.dart';
import 'package:ungexercies/utility/my_style.dart';

import 'dart:async';
import 'package:flutter/services.dart';
// import 'dart:core';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  
  double screen;
  String user, password, userID;
  bool statusRedEye = true;
  

  // Future<Null> _startLogin() async {
  //   // await _flutterLineLogin.startLogin(_onLoginSuccess, _onLoginError);
  //   // Begins the login process.
  //   await _flutterLineLogin.startLogin(_onLoginSuccess, _onLoginError);

  //   /// Success callback for LINE login result.
  //   ///
  //   /// The data is the map resulting from successful login with LINE login.
  //   ///
  //   /// Attributes from LineProfile & LineCredential
  //   ///
  //   /// * userID - The user's user ID.
  //   /// * displayName - The user’s display name.
  //   /// * pictureUrl - The user’s profile media URL.
  //   /// * statusMessage - The user’s status message.
  //   /// * accessToken - User access token.
  //   /// * expiresIn - The amount of time in milliseconds until the user access token expires.
  //   /// * permissions - The set of permissions that the access token holds. The following is a list of the permission codes.

  //   /// Error callback for LINE login result.
  //   ///
  //   /// The error is the PlatformException resulting of failing login with LINE login.
  //   /// Attributes differs between Android and iOS.
  // }

  void _onLoginError(Object error) {
    debugPrint("PlatformException: ${error}");
  }

  void _onLoginSuccess(Object data) async {
    print('data==>>$data');
    for (var item in data) {
      print('item==>>${item[userID]}');
    }
    //  print('userID=>>${data[userID]}');
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.signInAnonymously().then((value) async {
        print('value==>>$value');
      });
    }).catchError((value) {});
    // /flutter (19404): data==>>{userID: U1a9e2fb5b12766a9504a0a1026eba064, displayName: LEK, accessToken: eyJhbGciOiJIUzI1NiJ9.iEJQxt17wVpE9YQ3C6vfBMx_1_lpPLUwR44poo8bJba-UMTqvAOPAWoVQU9hwRusxsaRGLQWcYmMH1P2O20dTNWbaUKNd6FD8-WQYmrlJ973VexprQGiSDBL7UDHx_PYAVQV2gqQZbxtZdl7od7r11D8DOt7Z2VIGBPjwctm4Jk.WB_UeJAq7JaRlEeKjUoqkpJWaaYGJUoI7KIfZA-_8xU, expiresIn: 2592000000, permissions: [profile, openid], pictureUrl: https://profile.line-scdn.net/0hBFocydnPHWlSGjRk7kRiPm5fEwQlNBshKntQCXYcFl4qKF1oanVaCnJPS118Lwk8bnVXXXAeQV4q, statusMessage: "จินตนาการสำคัญกว่าความรู้" เป็นวลีอันอมตะที่อัลเบิร์ต ไอน์สไตน์ทิ้งเอาไว้ให้แก่โลก ความรู้ทำให้เราฉลาดขึ้น แต่มันจะเป็นสิ่งที่อยู่คงเดิมอย่างนั้น หากเราไม่นำความรู้นั้นไปใส่�
    // debugPrint("userID:${data.userID}");
    // debugPrint("displayName:${data['displayName']}");
    // debugPrint("pictureUrl:${data['pictureUrl']}");
    // debugPrint("statusMessage:${data['statusMessage']}");
    // debugPrint("accessToken: ${data['accessToken']}.");
    // debugPrint("expiresIn: ${data['expiresIn']}.");
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: buildCreateAccount(),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.0,
            colors: [MyStyle().darkColor, MyStyle().lightColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLogo(),
                MyStyle().titleH1('WAWA'),
                buildUser(),
                buildPassword(),
                buildLogin(),
                // Row(mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     RaisedButton(
                //         child: Text('Login'), onPressed: () => _startLogin()),
                //   ],
                // ),
              ],
            ),
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
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => user = value.trim(),
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: MyStyle().darkColor),
          hintText: 'User :',
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

  buildCreateAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Account ?'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/createAccount'),
            child: MyStyle().titleH2('Create Account'),
          ),
        ],
      );

  Container buildLogin() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: ElevatedButton(
        style: MyStyle().buttonStyle(),
        onPressed: () {
          if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(context, 'Have Space ?', 'Please fill Every Blank');
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      decoration: MyStyle().boxDecoration(),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.7,
      child: TextField(
        obscureText: statusRedEye,
        onChanged: (value) => password = value.trim(),
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              statusRedEye
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined,
              color: MyStyle().darkColor,
            ),
            onPressed: () {
              setState(() {
                statusRedEye = !statusRedEye;
              });
            },
          ),
          hintStyle: TextStyle(color: MyStyle().darkColor),
          hintText: 'Password :',
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

  Container buildLogo() {
    return Container(
      width: screen * 0.35,
      child: MyStyle().showLogo(100,100),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: password)
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, '/homePage', (route) => false))
          .catchError(
            (value) => normalDialog(context, value.code, value.message),
          );
    });
  }
}
