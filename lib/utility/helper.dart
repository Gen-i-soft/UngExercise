import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  Helper();

  Future setStorage(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future getStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
     

  String timestampToTime(DateTime date) {
    var strDate = new DateFormat.Hm().format(date);
    return strDate;
  }
}
