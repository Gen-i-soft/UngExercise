import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ungexercies/router.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';

String initialRoute = '/authenn';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //   LineSDK.instance.setup('1655667654').then((_) {
  //   print('LineSDK Prepared');
  //   runApp(MyApp());
  // });
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        initialRoute = '/homePage';
      }
      runApp(MyApp());
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (!focusScopeNode.hasPrimaryFocus &&
            focusScopeNode.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child),
            localizationsDelegates: [
   GlobalMaterialLocalizations.delegate,
   GlobalWidgetsLocalizations.delegate, //แคะไม่ตรงก็ไม่ได้จ้า .yaml
 ],
 supportedLocales: [
   Locale('th','TH')
 ],
      
        theme: ThemeData(primaryColor: Color(0xffB7B7B7), fontFamily: 'Angsa'),
        debugShowCheckedModeBanner: false,
        routes: map,
        initialRoute: initialRoute,
      ),
    );
  }
}
