import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{

static Future<bool> saveData({required String key,required String value})async{
    var shp = await SharedPreferences.getInstance();
    shp.setString(key, value);
    return true;
}


static Future<String?> getData({required String key})async{
  var shp = await SharedPreferences.getInstance();
  return shp.getString(key);
}

}