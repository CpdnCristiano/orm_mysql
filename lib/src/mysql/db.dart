import 'package:mysql1/mysql1.dart';

class MySQL {
  static MySqlConnection _connection;
  int characterSet;
  String db;
  String host;
  int maxPacketSize;
  String password;
  int port;
  Duration timeout;
  bool useCompression;
  bool useSSL;
  String user;

  MySQL(
      {this.host = 'localhost',
      this.port = 3306,
      this.user,
      this.password,
      this.db,
      this.useCompression = false,
      this.useSSL = false,
      this.maxPacketSize = 16 * 1024 * 1024,
      this.timeout = const Duration(seconds: 30),
      this.characterSet = CharacterSet.UTF8});

  Future<void> init() async {
    ConnectionSettings settings = new ConnectionSettings(
        characterSet: characterSet,
        db: db,
        host: host,
        maxPacketSize: maxPacketSize,
        password: password,
        port: port,
        timeout: timeout,
        useCompression: useCompression,
        useSSL: useSSL,
        user: user);
    _connection = await MySqlConnection.connect(settings);
    return _connection;
  }

  Future<void> close() async {
    _connection.close();
  }

  static MySqlConnection get connection => _connection;
}
