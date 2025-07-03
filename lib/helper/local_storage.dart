import 'package:shared_preferences/shared_preferences.dart';

Future<void> addDataToLocalStorage(
    {required String name, required String value}) async {
  final preference = await SharedPreferences.getInstance();
  preference.setString(name, value);
}

Future<dynamic> getDataFromLocalStorage({required String name}) async {
  final preference = await SharedPreferences.getInstance();
  return preference.getString(name);
}

Future<void> removeDataFromLocalStorage({required String name}) async {
  final preference = await SharedPreferences.getInstance();
  preference.remove(name);
}
