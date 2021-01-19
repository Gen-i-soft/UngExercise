import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ungexercies/models/exercise_model.dart';
import 'package:ungexercies/utility/dialog.dart';
import 'package:ungexercies/utility/my_style.dart';

class Exercise extends StatefulWidget {
  final String idDoc;
  final String idDocCatigory;
  Exercise({Key key, this.idDoc, this.idDocCatigory}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  String idDoc, idDocCatigory, dateTimeStr;
  bool statusLoad = true;
  bool statusNoData = true;
  List<ExerciseModel> exerciseModels = List();
  int index = 0;
  //  List<int> answers = List();
  int choiceChoose;
  int score = 0;
  bool statusShowAnswer = false;
  bool statusButton = true;
  List<Widget> answerIconWidgets = [
    Icon(Icons.clear, color: Colors.red),
    Icon(Icons.clear, color: Colors.red),
    Icon(Icons.clear, color: Colors.red),
    Icon(Icons.clear, color: Colors.red)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idDoc = widget.idDoc;
    idDocCatigory = widget.idDocCatigory;

    print('idDoc =$idDoc');
    readData();
  }

  Future<Null> sleepTime3() async {
    await Timer(Duration(seconds: 6), () {
      setState(() {
        statusButton = true;
      });
    });
  }

  Future<Null> sleepTime2() async {
    Duration duration = Duration(seconds: 4);
    await Timer(duration, () {
      normalDialog(context, 'Exercise Finish', 'You Score= $score');
    });
  }

  Future<Null> sleepTime() async {
    Duration duration = Duration(seconds: 3);
    await Timer(duration, () {
      if (!statusShowAnswer) {
        setState(() {
          statusShowAnswer = true;
          sleepTime();
        });
      } else {
        gotoStart();
        setState(() {
          statusShowAnswer = false;
        });
      }
    });
  }

  Future<Null> readData() async {
    DateTime dateTime = DateTime.now();
    setState(() {
      dateTimeStr = DateFormat('dd-MM-yyyy').format(dateTime);
    });

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('MainCatigory')
          .doc(idDocCatigory)
          .collection('SubCatigory')
          .doc(idDoc)
          .collection('Exercise')
          .orderBy('item')
          .snapshots()
          .listen((event) {
        print('event at exercise = ${event.docs}');

        setState(() {
          statusLoad = false;
        });

        if (event.docs.length != 0) {
          setState(() {
            statusNoData = false;
          });

          for (var item in event.docs) {
            ExerciseModel model = ExerciseModel.fromMap(item.data());
            // answers.add(0);

            setState(() {
              exerciseModels.add(model);
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primartColor,
        title: Text('Exercise'),
      ),
      body: statusLoad
          ? MyStyle().showProgress()
          : statusNoData
              ? MyStyle().titleH1Dark('No Exercise')
              : Container(
                  child: Column(
                    children: [
                      buildTopPanel(),
                      buildContainerExercise(),
                      buildAnswer(),
                    ],
                  ),
                ),
    );
  }

  Container buildAnswer() {
    return Container(
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: statusButton ? Colors.blue : Colors.red),
        onPressed: () {
          if (statusButton) {
            sleepTime3();
            setState(() {
              statusButton = false;
            });
            answerIconWidgets[exerciseModels[index].answer] = Icon(
              Icons.check,
              color: Colors.green,
            );

            sleepTime();
            if (choiceChoose == exerciseModels[index].answer) {
              setState(() {
                score++;
              });
            }

            if (index < exerciseModels.length - 1) {
              setState(() {
                index++;
              });
            } else {}

            print('You choose answer -> $choiceChoose');
          }
        },
        child: Text(statusButton ? 'Answer' : 'Please Wait'),
      ),
    );
  }

  Container buildContainerExercise() {
    String choice1 = exerciseModels[index].choice[0];
    String choice2 = exerciseModels[index].choice[1];
    String choice3 = exerciseModels[index].choice[2];
    String choice4 = exerciseModels[index].choice[3];

    return Container(
      width: 300,
      // color: Colors.grey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('${exerciseModels[index].item}. '),
                  Text('${exerciseModels[index].question}'),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 200,
                    child: RadioListTile(
                      title: Text(choice1),
                      value: 0,
                      groupValue: choiceChoose,
                      onChanged: (value) {
                        setState(() {
                          choiceChoose = value;
                        });
                      },
                    ),
                  ),
                  statusShowAnswer ? answerIconWidgets[0] : SizedBox(),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 200,
                    child: RadioListTile(
                      title: Text(choice2),
                      value: 1,
                      groupValue: choiceChoose,
                      onChanged: (value) {
                        setState(() {
                          choiceChoose = value;
                        });
                      },
                    ),
                  ),
                  statusShowAnswer ? answerIconWidgets[1] : SizedBox(),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 200,
                    child: RadioListTile(
                      title: Text(choice3),
                      value: 2,
                      groupValue: choiceChoose,
                      onChanged: (value) {
                        setState(() {
                          choiceChoose = value;
                        });
                      },
                    ),
                  ),
                  statusShowAnswer ? answerIconWidgets[2] : SizedBox(),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 200,
                    child: RadioListTile(
                      title: Text(choice4),
                      value: 3,
                      groupValue: choiceChoose,
                      onChanged: (value) {
                        setState(() {
                          choiceChoose = value;
                        });
                      },
                    ),
                  ),
                  statusShowAnswer ? answerIconWidgets[3] : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildTopPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyStyle().titleH2dark(
                    dateTimeStr == null ? 'Date :' : 'Date : $dateTimeStr'),
                MyStyle().titleH2dark(
                    'Item: ${exerciseModels[index].item}/${exerciseModels.length}')
              ],
            ),
            MyStyle().titleH1Dark('Score : $score')
          ],
        ),
      ),
    );
  }

  void gotoStart() {
    for (var i = 0; i < 4; i++) {
      answerIconWidgets[i] = Icon(Icons.clear, color: Colors.red);
    }
    choiceChoose = null;
  }
}
