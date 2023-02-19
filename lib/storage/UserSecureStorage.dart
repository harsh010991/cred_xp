
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage{
  static const _storage = FlutterSecureStorage();

  static const _keyAuth = 'auth';

  static Future setAuth(String auth) async{
    await _storage.write(key: _keyAuth, value: auth);
  }

  static Future<String?> getAuth() async =>
      await _storage.read(key: _keyAuth);
}