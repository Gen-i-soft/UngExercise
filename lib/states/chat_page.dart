import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:ungexercies/utility/helper.dart';
import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/widget/customer_chat.dart';
import 'package:ungexercies/widget/employee_chat.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Helper helper = Helper();
  final dbRef = FirebaseFirestore.instance;
  TextEditingController ctrlMessage = TextEditingController();
  ScrollController listController;
  String uID;

  Future callEmployee() async {}

  void showToast(String msg) {
    Toast.show(msg, context,
        backgroundColor: Colors.orange[100],
        textColor: Colors.orange[800],
        duration: 3);
  }

  Future sendMessage(String message) async {
    String _uId = await helper.getStorage('uid');
    try {
      await dbRef.collection('chat').doc(_uId).collection('messages').add({
        "isOpened": false,
        "message": message,
        "time": new DateTime.now().millisecondsSinceEpoch,
        "uid": _uId,
        "type": "CUSTOMER"
      });

      //chat-dashboard

      QuerySnapshot qsDasboard = await dbRef
          .collection('chats-dashboard')
          .where('orderId', isEqualTo: _uId)
          .get();

      if (qsDasboard.docs.length == 0) {
        //create
        await dbRef.collection('chats-dashboard').add({
          "isOpened": false,
          "message": message,
          "orderId": _uId,
          "time": new DateTime.now().millisecondsSinceEpoch,
        });
      } else {
        //update
        await dbRef
            .collection('chats-dashboard')
            .doc(qsDasboard.docs[0].id)
            .update({
          "message": message,
          "time": new DateTime.now().millisecondsSinceEpoch,
          "isOpened": false,
        });
      }

      if (listController.hasClients) {
        listController.jumpTo(listController.position.maxScrollExtent);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future findUid() async {
    String _uId = await helper.getStorage('uid');
    setState(() {
      uID = _uId;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listController = ScrollController(keepScrollOffset: true);
    findUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        // resizeToAvoidBottomPadding: true,
        // resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            'ระบบแชทกับผู้ขาย',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TextFormField(
            controller: ctrlMessage,
            style: TextStyle(fontSize: 22),
            decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: 'พิมพ์ข้อความ...',
                contentPadding: EdgeInsets.all(10),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (ctrlMessage.text.isNotEmpty) {
                      String message = ctrlMessage.text;
                      print('message>>>$message');
                      sendMessage(message);
                      setState(() {
                        ctrlMessage.clear();
                      });
                    }
                  },
                )),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.chat,
                    color: Colors.pink,
                    size: 32,
                  ),
                  Text(
                    'แชทกับผู้ขาย',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // FlatButton.icon(
                  //   onPressed: () {
                  //     callEmployee();
                  //   },
                  //   icon: Icon(
                  //     Icons.alarm,
                  //     color: Colors.pink,
                  //   ),
                  //   label: Text(
                  //     'กดเรียกพนักงาน',
                  //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: dbRef
                    .collection('chat')
                    .doc(uID)
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return MyStyle().showProgress();
                 
                  //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
                  if (snapshot.hasError) {
                    print(snapshot.error);

                    return Text('${snapshot.error}');
                  }
                  return ListView(
                    controller: listController,
                    children: snapshot.data.docs.map((document) {
                      return document['type'] == 'CUSTOMER'
                          ? CustomerChatItem(
                              message: document,
                            )
                          : EmployeeChatItem(
                              message: document,
                            );
                    }).toList(),
                  );
                },

                // children: snapshot.data.docs.length > 0
              ),
            ),
          ],
        ));
  }
}
