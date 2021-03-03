import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:ungexercies/utility/helper.dart';
import 'package:ungexercies/widget/customer_chat.dart';
import 'package:ungexercies/widget/employee_chat.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Helper helper = new Helper();
  // Query query = FirebaseFirestore.instance.collection('chat');
  final dbRef = FirebaseFirestore.instance;
  TextEditingController ctrlMessage = TextEditingController();
  ScrollController listController;
  String uid;

  void showToast(String msg) {
    Toast.show(msg, context,
        backgroundColor: Colors.orange[100],
        textColor: Colors.orange[800],
        duration: 2);
  }

  Future sendMessage(String message) async {
    String _uid = await helper.getStorage('uid');

    setState(() {
      uid = _uid;
    });

      //    await dbRef
      //     .collection('larn8mobile')
      //     .document('y64sRawQi5skalZniDYh')
      //     .collection('chats')
      //     .document(_uId)
      //     .collection('messages')
      //     .add({
      //   "isOpened": false,
      //   "message": message,
      //   "time": new DateTime.now().millisecondsSinceEpoch,
      //   "uid": _uId,
      //   "type": "CUSTOMER"
      // });

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance.
      collection('chat')
           .doc(uid)
          .collection('messages')
      .add({
        "isOpened": false,
        "message": message,
        "time": new DateTime.now().millisecondsSinceEpoch,
        "uid": uid,
        "type": "CUSTOMER"
      });
      if (listController.hasClients) {
        listController.jumpTo(listController.position.maxScrollExtent);
      }
    });

    //chat-dashboard

    QuerySnapshot qsDasboard = await FirebaseFirestore.instance
        .collection('chats-dashboard')
        .where('orderId', isEqualTo: uid)
        .get();

    if (qsDasboard.docs.length == 0) {
      //create
      await FirebaseFirestore.instance
          .collection('chats-dashboard')         
         
          .add({
        "isOpened": false,
        "message": message,
        "orderId": uid,
        "time": new DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      //update
      await FirebaseFirestore.instance
          .collection('chats-dashboard')
          .doc(qsDasboard.docs[0].id)  
          .update({
        "message": message,
        "time": new DateTime.now().millisecondsSinceEpoch,
        "isOpened": false,
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listController = ScrollController(keepScrollOffset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 15),
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
                // stream: query.snapshots(),
                 stream: dbRef
                    
                    .collection('chat')
                    .doc(uid)
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),

                builder: (context, stream) {
                  //check error index >> หน้าขาวจ้า ข้อมูลไม่ออก
                  if (stream.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (stream.hasError) {
                    return Center(child: Text(stream.error.toString()));
                  }

                  QuerySnapshot querySnapshot = stream.data;

                  return ListView.builder(
                      itemCount: querySnapshot.size,
                      itemBuilder: (context, index) {
                        return querySnapshot.docs[index]['type'] == 'CUSTOMER'
                            ? CustomerChatItem(
                                message: querySnapshot.docs[index],
                              )
                            : EmployeeChatItem(
                                message: querySnapshot.docs[index],
                              );

                       
                      });
                }),
          ),
        ],
      ),
    );
  }
}
