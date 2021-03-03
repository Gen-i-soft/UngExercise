import 'package:flutter/material.dart';

import 'package:ungexercies/widget/product_box.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProductItemBox(imageurl: 'https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fcomplain.png?alt=media&token=8882de3f-5de7-413e-8a69-f6bcd3d7f801', 
          width: 150, height: 150),
         
          Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,
          color: Colors.red[600]),),
          SizedBox(height: 10,),
          Text(message,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,
          color: Colors.red[700]),),
           Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 34,color: Colors.orange[800]),)),
           
          ],
        ),




      ],),
      // ListTile(
      //   leading: Image.network('https://firebasestorage.googleapis.com/v0/b/product-52583.appspot.com/o/images%2Fcomplain.png?alt=media&token=8882de3f-5de7-413e-8a69-f6bcd3d7f801',
      //   width: 200,),
      //   title: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
      //   subtitle: Text(message,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
      // ),
      
    ),
  );
}
