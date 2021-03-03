import 'package:flutter/material.dart';
import 'package:ungexercies/states/syn_data_to_firebase.dart';
import 'package:ungexercies/states/sync_data_by_category.dart';

class SyncDataCentre extends StatefulWidget {
  @override
  _SyncDataCentreState createState() => _SyncDataCentreState();
}

class _SyncDataCentreState extends State<SyncDataCentre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบ Sync ข้อมูล'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SyncDataByCategory(),
                        ));
                      },
                      icon: Icon(
                        Icons.autorenew,
                        size: 32,
                      ),
                      label: Text('Syncข้อมูลด้วยหมวดหมู่สินค้า'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton.icon(
                      onPressed: () {
                           Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SynDataToFirebase(),
                        ));
                      },
                      icon: Icon(Icons.autorenew),
                      label: Text('Syncข้อมูลทั้งหมด'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
