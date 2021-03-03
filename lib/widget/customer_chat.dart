import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/utility/helper.dart';


class CustomerChatItem extends StatelessWidget {
  final DocumentSnapshot message;
  CustomerChatItem({@required this.message});

  @override
  Widget build(BuildContext context) {
    Helper helper = new Helper();
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(message['time']);
    
    return Container(
      padding: EdgeInsets.only(
        right: 10,
        left: 80,
        top: 10,
        bottom: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
        child: Container(
          color: Colors.indigo[100],
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 15),
                child: Text(
                  '${message['message']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(bottom: 1, right: 10, child: Text('${helper.timestampToTime(date)}น.'))
            ],
          ),
        ),
      ),
    );
  }
}
