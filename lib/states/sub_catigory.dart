import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/models/sub_catigory_model.dart';
import 'package:ungexercies/states/exercise.dart';
import 'package:ungexercies/utility/my_style.dart';

class SubCatigory extends StatefulWidget {
  final String idDoc;
  SubCatigory({Key key, this.idDoc}) : super(key: key);
  @override
  _SubCatigoryState createState() => _SubCatigoryState();
}

class _SubCatigoryState extends State<SubCatigory> {
  String idDoc;
  bool statusLoad = true;
  bool statusNoData = true;
  List<SubCatigoryModel> subCatigoryModels = List();
  List<String> idDocs = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idDoc = widget.idDoc;
    print('idDoc = $idDoc');
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('MainCatigory')
          .doc(idDoc)
          .collection('SubCatigory')
          .orderBy('name')
          .snapshots()
          .listen((event) {
        print('event=${event.docs}');

        setState(() {
          statusLoad = false;
        });

        if (event.docs.length != 0) {
          for (var item in event.docs) {
            SubCatigoryModel model = SubCatigoryModel.fromMap(item.data());
            String idDoc = item.id;
            idDocs.add(idDoc);
            setState(() {
              subCatigoryModels.add(model);
            });
          }

          setState(() {
            statusNoData = false;
          });
        }
      });
    });
  }

  // Future<Null> readSubCatigory() async {
  //   await Firebase.initializeApp().then((value) async{
  //     FirebaseFirestore.instance.collection('MainCatigory').doc(idDoc).
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Category'),
        backgroundColor: MyStyle().primartColor,
      ),
      body: statusLoad
          ? MyStyle().showProgress()
          : statusNoData
              ? Center(child: MyStyle().titleH1Dark('ยังไม่มี Sub Catigory'))
              : ListView.builder(
                  itemCount: subCatigoryModels.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Exercise(
                          idDoc: idDocs[index],
                          idDocCatigory: idDoc,
                        ),
                      ),
                    ),
                    child: Card(
                        color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyStyle()
                              .titleH1Dark(subCatigoryModels[index].name),
                        )),
                  ),
                ),
    );
  }
}
