import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ungexercies/models/sqlite_model.dart';
import 'package:ungexercies/utility/dialog.dart';
import 'package:ungexercies/utility/helper.dart';

import 'package:ungexercies/utility/my_style.dart';
import 'package:ungexercies/utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  final Function onAdItem;
  ShowCart({@required this.onAdItem});
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlMsg = TextEditingController();
  TextEditingController ctrlMsg2 = TextEditingController();
   TextEditingController ctrlDatetime = TextEditingController();
  List<SQLiteModel> sqliteModels = List();
  SQLiteModel sqLiteModel;
  // List<SQLiteModel<Map, dynamic>> sqliteModels = List();
  bool statusLoad = true;
  bool statusHaveData;
  List<List<String>> listunitcodes = List();
  List<List<String>> listPrices = List();
  List<String> models = List();
  List<Map<String, dynamic>> modelss = List();
  int no = 1;
  double total = 0;
  int index2 = 0;
  String dateTimeStr, timeStr, pathAPI;
  double lat1 = 0;
  double lng1 = 0;
  double distance;
  // WAWA lat lng
  double lat2 = 17.1284055;
  double lng2 = 102.9624795;
  Helper helper = new Helper();
  DateTime dateTime;
  String _way;

  Future<Null> findLat1Lng1() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
    });
    // print('lat####=$lat, lng####=$lng');
    distance = calculateDistance(lat1, lng1, lat2, lng2);
    print('distance###>>>$distance');
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));
    // print('distance==>>>$distance');

    return distance;
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> confirmDelete(int index) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ยืนยันการลบรายการ',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[600]),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 32,
                          color: Colors.brown[800],
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800]),
                        ),
                      ),
                      RaisedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);

                          await SQLiteHelper()
                              .deleteDataById(sqliteModels[index].id)
                              .then((value) {
                            readCart();
                            // widget.onAdItem();
                          });
                        },
                        icon: Icon(Icons.check,
                            size: 32, color: Colors.green[800]),
                        label: Text(
                          'ยืนยัน',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future<Null> confirmOrder() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ยืนยันการสร้างใบเสนอราคา',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700]),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 32,
                          color: Colors.brown[800],
                        ),
                        label: Text(
                          'ยกเลิก',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800]),
                        ),
                      ),
                      RaisedButton.icon(
                        onPressed: () {
                          if (lat1 == 0) {
                            normalDialog(context, 'แอพต้องการตำแหน่งปัจจุบัน',
                                'คุณต้องอนุญาตให้แอปใช้ตำแหน่งก่อนสร้างใบเสนอราคาครับ');
                          } else {
                            // normalDialog(
                            //     context, 'OK', 'ระยะที่ได้ คือ$distance');

                            sendDataToSML();
                          }
                        },
                        icon: Icon(Icons.check,
                            size: 32, color: Colors.green[800]),
                        label: Text(
                          'ยืนยัน',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCart();
    findLat1Lng1();
    dateTime = DateTime.now();
    // findLatLng();
    // print('#####at initState');
  }

  Future<Null> sendDataToSML() async {
    setState(() {
      sqliteModels.clear();
      models.clear();
      total = 0;
    });
    try {
      await SQLiteHelper().readSQLite().then((value) async {
        for (var string in value) {
          String sumString = string.subtotals;
          double sumDouble = double.parse(sumString);
          setState(() {
            total = total + sumDouble;
            sqliteModels.add(string);
            // var _jso = jsonEncode(string.toJsonzz());
            // print('_jso==>>$_jso');
            // models.add(_jso);
            var _jso = (string.toJsonzz());
            modelss.add(string.toJsonzz());

            // models.add(string.toJsonzz().toString());
          });
        } //end >for
      });
    } catch (e) {
      print('error SQlite===>${e.toString()}');
    }

    // for (var page = 8; page <= maxPage; page++) {

    Map<String, String> headers = Map();
    headers['GUID'] = 'smlx';
    headers['provider'] = 'DATA';
    headers['databasename'] = 'wawa2';
    headers['Content-Type'] = 'application/json';
    // headers['contentType'] = 'application/json';
    // print(headers);

    Map<String, dynamic> datas = Map();
    DateTime dateTime = DateTime.now();
    setState(() {
      dateTimeStr = DateFormat('yyyy-MM-dd').format(dateTime);
      timeStr = DateFormat('HH:mm').format(dateTime);
    });
    Random random = Random();
    int i = random.nextInt(100000);
    String docNo = 'WAWA-$i$dateTimeStr';

    datas['doc_no'] = docNo;
    datas['doc_format_code'] = 'QT';

    datas['doc_date'] = dateTimeStr; //now()
    datas['doc_time'] = timeStr; //now()
    datas['cust_code'] = 'AR00075'; //Gen
    datas['sale_code'] = '1056';
    datas['sale_type'] = 0;
    datas['vat_type'] = 1;
    datas['vat_rate'] = 7;
    datas['total_value'] = total;
    datas['total_discount'] = 0;
    datas['total_before_vat'] = total / 1.07;
    datas['total_vat_value'] = total - (total / 1.07);
    datas['total_except_vat'] = 0;
    datas['total_after_vat'] = total;
    datas['total_amount'] = total;
    datas['cash_amount'] = 0;
    datas['chq_amount'] = 0;
    datas['credit_amount'] = 0;
    datas['tranfer_amount'] = 0;

    datas['details'] = models;

    // debugPrint('datas>>$datas');
    //  print("LEK###>>>$models");
    var body2 = {
      "doc_no": "$docNo",
      "doc_format_code": "QT",
      "doc_date": "$dateTimeStr",
      "doc_time": "$timeStr",
      "cust_code": 'AR00075',
      "sale_code": '1056',
      "sale_type": 0,
      "vat_type": 1,
      "vat_rate": 7,
      "total_value": total,
      "total_discount": 0,
      "total_before_vat": total / 1.07,
      "total_vat_value": total - (total / 1.07),
      "total_except_vat": 0,
      "total_after_vat": total,
      "total_amount": total,
      "details": [
        {
          "item_code": "01-0152",
          "line_number": 0,
          "is_permium": 0,
          "unit_code": "ลัง12",
          "wh_code": "CMI01",
          "shelf_code": "CMI420",
          "qty": 3,
          "price": "2100.0",
          "price_exclude_vat": 1962.6168224299065,
          "discount_amount": 0,
          "sum_amount": "6300.0",
          "vat_amount": 137.3831775700935,
          "tax_type": 0,
          "vat_type": 1,
          "sum_amount_exclude_vat": 1962.6168224299065,
          "name": "นมผงคาร์เนชั่น1พลัสรสวานิลลา 900กรัม",
          "barcode": "08850127058482"
        }
      ]
    };

    // String _model = jsonEncode(models);
    // JSONObject obj = new JSONObject(test);

    var body = {
      "doc_no": "$docNo",
      "doc_format_code": "QT",
      "doc_date": "$dateTimeStr",
      "doc_time": "$timeStr",
      "cust_code": 'AR00075',
      "sale_code": '1056',
      "sale_type": 0,
      "vat_type": 1,
      "vat_rate": 7,
      "total_value": total,
      "total_discount": 0,
      "total_before_vat": total / 1.07,
      "total_vat_value": total - (total / 1.07),
      "total_except_vat": 0,
      "total_after_vat": total,
      "total_amount": total,
      "details": modelss
    };

    // var bodyex = jsonEncode(body);

    // print('##LEK>>>$body');

    FormData formData = new FormData.fromMap({
      "doc_no": docNo,
      "doc_format_code": "QT",
      "doc_date": dateTimeStr,
      "doc_time": timeStr,
      "cust_code": 'AR00075',
      "sale_code": '1056',
      "sale_type": 0,
      "vat_type": 1,
      "vat_rate": 7,
      "total_value": total,
      "total_discount": 0,
      "total_before_vat": total / 1.07,
      "total_vat_value": total - (total / 1.07),
      "total_except_vat": 0,
      "total_after_vat": total,
      "total_amount": total,
      "details": models
    });
    // debugPrint('formData==>>$formData.');

    // print(jsonEncode(datas));
    // normalDialog(context, "data", formData);

    pathAPI =
        'http://43.229.149.11:8080/SMLJavaRESTService/restapi/sales/quotation';
    // http://43.229.149.11:8080/SMLJavaRESTService/restapi/sales/quotation

    // Response response = await Dio().post("http://43.229.149.11:8080/SMLJavaRESTService/restapi/sales/quotation",data: formData,options: Options(headers: headers));
    // print('response==>>>$response');

    try {
      await Dio()
          .post(pathAPI,
              options: Options(headers: headers), data: jsonEncode(body))
          .then((value) async {
        String uid = await helper.getStorage('uid');
        String lineUser = await helper.getStorage('lineUserID');
        if (lineUser.length == 0) {
          setState(() {
            _way = 'from Email';
          });
        } else {
          setState(() {
            _way = 'from Line';
          });
        }
        await Firebase.initializeApp().then((value) async {
          await FirebaseFirestore.instance.collection('Report').add({
            "uid": uid,
            "way": _way,
            "totalValue": total,
            //
            "time": new DateTime.now().millisecondsSinceEpoch,
            "status": "OPEN",
            "lat": lat1,
            "lng": lng1,
            "docNo": docNo,
            "docTime": timeStr,
            "docDate": dateTimeStr,

            "distance": distance,
            "dateRecieve": dateTime,
            "message": ctrlMsg.text.trim()
          }).then((value) async {
            Navigator.pop(context);
            await SQLiteHelper().deleteAllData().then((value) {
              readCart();
            });
          });
        });
      }).catchError((value) {
        print('error in Dio().post method==>>${value.toString()}');
      });
      // print(response.data);
      // print(response.headers);
      // print(response.request);
      // print(response.statusCode);

    } on DioError catch (e) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);

      print(e.request.data);
      print(e.request);
      print(e.message);
    }
  }

  Future<Null> readCart() async {
    // print('##############>>>>readCart work ');
    // if (total > 0) {
    //   setState(() {
    //     total = 0;
    //   });
    // }
    setState(() {
      sqliteModels.clear();
      models.clear();
      total = 0;
    });

    try {
      await SQLiteHelper().readSQLite().then((value) {
        // print('value==>>>${value.toString()}');
        //  String _value =;
        // print('_value===>>>$_value');

        for (var string in value) {
          String sumString = string.subtotals;
          double sumDouble = double.parse(sumString);
          setState(() {
            total = total + sumDouble;
            sqliteModels.add(string);
            var _jso = jsonEncode(string.toJsonzz());
            models.add(_jso);
          });
        }
        // models.add(sqliteModels);
        // print('models===>>$models');

        // var _value = SQLiteModel.fromMap(sqliteModels);
        //  var _value = jsonDecode(sqliteModels.toString());

        setState(() {
          statusLoad = false;
        });

        if (value.length != 0) {
          // total = double.parse(value[index2].subtotals);
          setState(() {
            sqliteModels = value;
            statusHaveData = true;
          });
        } else {
          setState(() {
            statusHaveData = false;
          });
        }
      });
    } catch (e) {
      // print('########### status in SQLite ===>>> ${e.toString()}');
    }
    widget.onAdItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('ตะกร้าของฉัน'),
      // ),
      body: statusLoad
          ? MyStyle().showProgress()
          : statusHaveData
              ? Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ตะกร้าของฉัน',
                              style: TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        buildListView(),
                        buildRowTotal(),
                        SizedBox(
                          height: 10,
                        ),
                        // buildRowMap(),
                        SizedBox(
                          height: 5,
                        ),
                        buildRowMessage(),
                        showDate(),

                        SizedBox(
                          height: 20,
                        ),

                        buildCloudButton(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('ยังไม่มีของในตะกร้า')),
    );
  }

  Widget showMap() {
    LatLng latLng = LatLng(14.8777294, 103.4895756);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    //14.8777294,103.4895756,
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.hybrid,
        onMapCreated: (controller) {},
      ),
    );
  }

  Row buildCloudButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton.icon(
          height: 60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)
                // topLeft: Radius.circular(20),
                // bottomLeft: Radius.circular(20),
                ),
          ),
          color: Colors.red[600],
          onPressed: () {
            confirmOrder();
          },
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.white,
            size: 32,
          ),
          label: Text(
            'สร้างใบเสนอราคา',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRowMap() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            size: 32,
          ),
          Text(
            'ที่อยู่:...........................',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          // Icon(Icons.create,size: 32,),
        ],
      ),
    );
  }

  Widget buildRowMessage() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          TextField(
            controller: ctrlMsg,
            // onChanged: (value) => user = value.trim(),
            // keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: MyStyle().darkColor,
                fontSize: 22,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              // hintStyle: TextStyle(color: MyStyle().darkColor),
              // hintText: 'อีเมล์ :',
              labelText: 'ข้อความถึงผู้ขาย',
              labelStyle: TextStyle(
                  fontSize: 20,
                  color: Color(0xff980700),
                  fontWeight: FontWeight.bold),

              prefixIcon: Icon(
                Icons.perm_identity,
                color: MyStyle().darkColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: MyStyle().darkColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: MyStyle().lightColor),
              ),
            ),
          ),

          // Container(width: 300,
          //   child: TextFormField(
          //     controller: ctrlMsg,
          //     style: TextStyle(
          //         fontSize: 28,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.orange[700]),
          //   ),
          // ),
        ],
      ),
    );
  }

  Row buildRowTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            'รวมทั้งสิ้น',
            style: TextStyle(
              fontSize: 32,
              color: Colors.red,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange[300]),
            child: Text(
              MyStyle().myFormat.format(total),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget showDate() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'เลือกวันที่รับสินค้า',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
        ListTile(
          leading: Icon(
            Icons.date_range,
            size: 32,
          ),
          title: TextFormField(
             controller: ctrlDatetime,
              style: TextStyle(
                color: MyStyle().darkColor,
                fontSize: 22,
                fontWeight: FontWeight.bold),
                

          ),
          // Text(
          //   '${dateTime.day} - ${dateTime.month} - ${dateTime.year+543}',
          //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          // ),
          trailing: Icon(Icons.keyboard_arrow_down, size: 32),
          onTap: () {
            chooseDate();
          },
        ),
      ],
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${index + 1}. ${sqliteModels[index].name}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    // print('you delete id= ${sqliteModels[index].id}');
                    confirmDelete(index);
                  })
            ],
          ),
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: sqliteModels[index].picturl,
                  errorWidget: (context, url, error) =>
                      Image.asset('images/image.png'),
                  placeholder: (context, url) => MyStyle().showProgress(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(sqliteModels[index].barcodes),
                    // Text(sqliteModels[index].name),
                    Row(
                      children: [
                        Text(
                          'ราคา:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                          MyStyle()
                              .myFormat
                              .format(double.parse(sqliteModels[index].prices)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                          ' บาท',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Text(
                          'จำนวน:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                            '${sqliteModels[index].amounts} x ${sqliteModels[index].units}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),

                    Row(
                      children: [
                        Text(
                          'ราคารวม:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        Text(
                          MyStyle().myFormat.format(
                              double.parse(sqliteModels[index].subtotals)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.red),
                        ),
                        Text(
                          ' บาท',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 0.8,
          )
        ],
      ),
    );
  }

  Future<void> chooseDate() async {
    DateTime chooseDateTime = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: Colors.black,
                accentColor: Colors.orange[600],
                colorScheme: ColorScheme.light(primary: Colors.black),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary)),
            child: child);
      },
    );
    if (chooseDateTime != null) {
      String strDate = new DateFormat.MMMMd('th_TH').format(chooseDateTime);
      String _strDate = '$strDate ${chooseDateTime.year + 543}';

      setState(() {
       ctrlDatetime.text = _strDate;
      });
    }
  }
}
