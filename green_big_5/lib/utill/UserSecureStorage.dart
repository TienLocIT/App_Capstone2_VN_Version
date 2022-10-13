// @dart=2.9
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class UserSecureStorage{
  static final _storage=FlutterSecureStorage();
  static final _keyUser="phoneNumber";
  static void setUserValue(String phoneNumber) async=>
      _storage.write(key: _keyUser,  value:phoneNumber);
  static Future<String> getUserValue()=>
      _storage.read(key: _keyUser);
  static Future deletePhoneNumber()=>
      _storage.delete(key: _keyUser);
}