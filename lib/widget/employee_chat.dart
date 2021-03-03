import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/utility/helper.dart';



class EmployeeChatItem extends StatelessWidget {
  final DocumentSnapshot message;
  EmployeeChatItem({@required this.message});
  @override
  Widget build(BuildContext context) {
    Helper helper = new Helper();
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(message['time']);
    
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.record_voice_over),
      ),
      title: Text('พนักงาน'),
      subtitle: Text('${message['message']}'),
      trailing: Text('${helper.timestampToTime(date)}น.'),
    );
  }
}
