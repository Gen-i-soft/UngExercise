import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/utility/my_style.dart';

class Exercise extends StatefulWidget {
  final String idDoc;
  final String idDocCatigory;
  Exercise({Key key, this.idDoc, this.idDocCatigory}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  String idDoc, idDocCatigory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idDoc = widget.idDoc;
    idDocCatigory = widget.idDocCatigory;

    print('idDoc =$idDoc');
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('MainCatigory')
          .doc(idDocCatigory)
          .collection('SubCatigory')
          .doc(idDoc)
          .collection('Exercise')
          .snapshots()
          .listen((event) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primartColor,
        title: Text('Exercise'),
      ),
    );
  }
}
