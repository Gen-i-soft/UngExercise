import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:ungexercies/utility/helper.dart';
import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/widget/customer_chat.dart';
import 'package:ungexercies/widget/employee_chat.dart';

class ChatAdminPage extends StatefulWidget {
  final DocumentSnapshot document;
  ChatAdminPage({@required this.document});
  @override
  _ChatAdminPageState createState() => _ChatAdminPageState();
}

class _ChatAdminPageState extends State<ChatAdminPage> {
  Helper helper = Helper();
  final dbRef = FirebaseFirestore.instance;
  TextEditingController ctrlMessage = TextEditingController();
  ScrollController listController;
  String uID;

  void showToast(String msg) {
    Toast.show(msg, context,
        backgroundColor: Colors.orange[100],
        textColor: Colors.orange[800],
        duration: 2);
  }

  Future sendMessage(String message) async {
    // String _uId = await helper.getStorage('uid');
    try {
      await dbRef
          .collection('chat')
          .doc(widget.document['orderId'])
          .collection('messages')
          .add({
        "isOpened": false,
        "message": message,
        "time": new DateTime.now().millisecondsSinceEpoch,
        "uid": widget.document['orderId'],
        "type": "EMPLOYEE"
      });

      //chat-dashboard

      // QuerySnapshot qsDasboard = await dbRef
      //     .collection('larn8mobile')
      //     .document('y64sRawQi5skalZniDYh')
      //     .collection('chats-dashboard')
      //     .where('orderId', isEqualTo: widget.document['orderId'])
      //     .getDocuments();

      // if (qsDasboard.documents.length == 0) {
      //   //create
      //   await dbRef
      //       .collection('larn8mobile')
      //       .document('y64sRawQi5skalZniDYh')
      //       .collection('chats-dashboard')
      //       .add({
      //     "isOpened": false,
      //     "message": message,
      //     "orderId": widget.document['orderId'],
      //     "time": new DateTime.now().millisecondsSinceEpoch,
      //   });
      // } else {
      //   //update
      //   await dbRef
      //       .collection('larn8mobile')
      //       .document('y64sRawQi5skalZniDYh')
      //       .collection('chats-dashboard')
      //       .document(qsDasboard.documents[0].documentID)
      //       .updateData({
      //     "message": message,
      //     "time": new DateTime.now().millisecondsSinceEpoch,
      //     "isOpened": false,
      //   });
      // }

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
    // findUid();
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
          'ระบบแชทกับลูกค้า',
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
                  'แชทกับลูกค้า',
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
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [Text('ไอดี:${widget.document['orderId']}')],
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: dbRef
                    .collection('chat')
                    .doc(widget.document['orderId'])
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
                  if (snapshot.data == null) return MyStyle().showProgress();
                  if (snapshot.hasError) {
                    print(snapshot.error);

                    return Text('${snapshot.error}');
                  }
                  return ListView(
                    controller: listController,
                    children: snapshot.data.docs.length > 0
                        ? snapshot.data.docs.map((e) {
                            return e['type'] == 'CUSTOMER'
                                ? CustomerChatItem(
                                    message: e,
                                  )
                                : EmployeeChatItem(
                                    message: e,
                                  );
                          }).toList()
                        : [],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
