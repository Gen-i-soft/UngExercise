import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  final Function(DocumentSnapshot) onChange;
  CategoryWidget({@required this.onChange});
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // params
  // final dbRef = Firestore.instance;

  // List<CategoryModel> categoryModels = List();
  bool loading = false;
  String selectedCategory = "004";
  List<DocumentSnapshot> categories = [];

  Future getCategory() async {
    setState(() {
      loading = true;
    });
    await Firebase.initializeApp().then((value) async {
      try {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('category').get();

        setState(() {
          categories = snapshot.docs;
          loading = false;
          if (categories.length > 0) {
            selectedCategory = categories[0]['itemcode'];
            widget.onChange(categories[0]);
          }
        });

        // await FirebaseFirestore.instance
        //     .collection('category')
        //     .orderBy('name')
        //     .snapshots()
        //     .listen((event) {
        //   int index = 0;

        //   for (var snapshot in event.docs) {
        //     index++;
        //     CategoryModel model = CategoryModel.fromMap(snapshot.data());
        //     setState(() {
        //       categoryModels.add(model);
        //     });
        //   }
        // });
      } catch (e) {
        print('e>>> ${e.toString()}');
      }
    });

    // .document('yeRSeBlZRuU9xg0p2CrO')
    // .collection('categories')
    // .where('isPromotion',isEqualTo: true)
    // .getDocuments();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Text(
            'หมวดหมู่สินค้า',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                //จับมา map ใหม่
                children: categories.map((DocumentSnapshot document) {
                  return GestureDetector(
                    onTap: () {
                      // print(document['categoryName']);
                      widget.onChange(document);
                      setState(() {
                        selectedCategory = document['itemcode'];
                        // selectedCategory = document.reference;  >> work
                        print('selected==>>$selectedCategory');
                      });
                    },
                    child: Chip(
                      label: Text(
                        '${document['name']}',
                        style: selectedCategory == document['itemcode']
                            ? TextStyle(color: Colors.white, fontSize: 24)
                            : TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      backgroundColor: selectedCategory == document['itemcode']
                          ? Colors.black
                          : Colors.black26,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ))
      ],
    );
  }
}
