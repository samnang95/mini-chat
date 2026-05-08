abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // final SharedPreferences prefs;  ← inject storage here

  AuthLocalDataSourceImpl();

  @override
  Future<void> cacheToken(String token) async {
    // TODO: Implement with SharedPreferences or Hive
    // await prefs.setString(StorageKeys.authToken, token);
    throw UnimplementedError();
  }

  @override
  Future<String?> getToken() async {
    // TODO: Implement with SharedPreferences or Hive
    // return prefs.getString(StorageKeys.authToken);
    throw UnimplementedError();
  }

  @override
  Future<void> clearToken() async {
    // TODO: Implement with SharedPreferences or Hive
    // await prefs.remove(StorageKeys.authToken);
    throw UnimplementedError();
  }
}
