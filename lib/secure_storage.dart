import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
 Future updateToken(String token) async {
    await _storage.write(key: 'token', value: token, aOptions: _getAndroidOptions());
  }

  Future<String?> getToken() async{
    return await _storage.read(key: 'token', aOptions: _getAndroidOptions());
  }

  deleteToken() async{
    return await _storage.delete(key: 'token');
  }
}
