import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ungexercies/admin/adminmap.dart';
import 'package:ungexercies/utility/my_style.dart';

class AdminOrderPage extends StatefulWidget {
  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  Query query = FirebaseFirestore.instance
      .collection('Report')
      .orderBy('time', descending: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.pink,
                    size: 32,
                  ),
                  Text(
                    'รายการออร์เดอร์สินค้า',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: query.snapshots(),
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
                          // Helper helper = new Helper();

                          // DateTime dateRecieve =
                          //     new DateTime.fromMillisecondsSinceEpoch();

                          String _total = MyStyle()
                              .myFormat
                              .format(querySnapshot.docs[index]['totalValue']);
                          String _distance = MyStyle()
                              .myFormat
                              .format(querySnapshot.docs[index]['distance']);

                          return Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}. เลขที่เอกสาร:${querySnapshot.docs[index]['docNo']}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'วันที่ออกใบเสนอราคา:${querySnapshot.docs[index]['docDate']}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'สถานะออร์เดอร์:${querySnapshot.docs[index]['status']}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'มูลค่าทั้งหมด:$_total',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'วันที่ต้องการรับสินค้า:',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.red),
                                ),
                                Text(
                                  'ระยะทาง:$_distance' 'กิโลเมตร',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.red),
                                ),
                                Text(
                                  'ละติจูด:${querySnapshot.docs[index]['lat']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  'ลองติจูด:${querySnapshot.docs[index]['lng']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                 Text(
                                  'เบอร์โทร:',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),),
                                  Text(
                                  'สถานะลูกค้า:',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                RaisedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdminMap(message: querySnapshot.docs[index]),
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.place,
                                      size: 24,
                                    ),
                                    label: Text(
                                      'แสดงในแผนที่',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    )),  
                                    RaisedButton.icon(onPressed: (){}, icon: Icon(Icons.print), label: Text('พิมพ์ใบเสนอราคา',style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                    ,)),
                                Divider(),
                              ],
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
