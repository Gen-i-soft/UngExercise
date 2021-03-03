import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/utility/sqlite_helper.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  //Mehtod
  Future<Null> confirmSignOut() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการออกจากระบบใช่มั้ยครับ'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.remove,
                  size: 32,
                  color: Colors.brown[800],
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.brown[500],
                      fontWeight: FontWeight.bold),
                ),
              ),
              RaisedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);

                  await SQLiteHelper().deleteAllData().then((value) {
                    signOut();
                  });
                },
                icon: Icon(
                  Icons.check,
                  size: 32,
                  color: Colors.orange[800],
                ),
                label: Text(
                  'ยืนยัน',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.orange[500],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> signOut() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/authenn', (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                children: [
          ListTile(leading: Icon(Icons.exit_to_app,size: 32,color: Colors.black,),
          title: Text('ออกจากระบบ',style: TextStyle(fontWeight: FontWeight.bold,
          fontSize: 32,color: Colors.black),),
          trailing: Icon(Icons.arrow_right,size: 32,),
          onTap: () {
            confirmSignOut();
          },),
          Divider()
        ],),
      ),

      
    );
  }
}