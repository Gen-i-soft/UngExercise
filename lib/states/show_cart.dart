import 'package:flutter/material.dart';
import 'package:ungexercies/models/sqlite_model.dart';
import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = List();
  bool statusLoad = true;
  bool statusHaveData;
  List<List<String>> listunitcodes = List();
  List<List<String>> listPrices = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCart();
  }

  Future<Null> readCart() async {
    print('##############>>>>readCart work ');
    try {
      await SQLiteHelper().readSQLite().then((value) {
        setState(() {
          statusLoad = false;
        });

        if (value.length != 0) {
          setState(() {
            sqliteModels = value;
            statusHaveData = true;

            List<String> unitcodes = List();
            List<String> prices = List();

            for (var item in sqliteModels) {
              unitcodes = createArrayFromString(item.units);
              listunitcodes.add(unitcodes);

              prices = createArrayFromString(item.prices);
              listPrices.add(prices);
            }
          });
        } else {
          setState(() {
            statusHaveData = false;
          });
        }
      });
    } catch (e) {
      print('########### status in SQLite ===>>> ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: statusLoad
          ? MyStyle().showProgress()
          : statusHaveData
              ? buildListView()
              : Center(child: Text('ยังไม่มีของในตะกร้า')),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MyStyle().titleH2dark(sqliteModels[index].name),
              IconButton(icon: Icon(Icons.delete), onPressed: (){})
            ],
          ),
          Row(
            children: [Text('header')],
          ),
          ListView.builder(physics: ScrollPhysics(),
          shrinkWrap: true,
            itemCount: listunitcodes[index].length,
            itemBuilder: (context, index2) =>
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(listunitcodes[index][index2]),
                    Text(listPrices[index][index2]),
                    
                  ],
                ),
          )
        ],
      ),
    );
  }

  List<String> createArrayFromString(String string) {
    List<String> strings = List();
    print('string ===>> $string');

    String result = string.substring(1, string.length - 1);
    print('result = $result');

    strings = result.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }

    return strings;
  }
}
