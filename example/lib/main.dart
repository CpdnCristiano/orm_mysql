import 'package:example/config.dart';
import 'package:get_server/get_server.dart';
import 'package:orm_mysql/orm_mysql.dart';
import 'routes/app_pages.dart';

void main() async {
  MySQL db = MySQL(
    host: Config.host,
    user: Config.user,
    password: Config.password,
    db: Config.db,
  );
  await db.init();

  await runApp(GetServer(
    getPages: AppPages.routes,
  ));
}
