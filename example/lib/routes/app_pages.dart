import 'package:example/modules/user/add_user.dart';
import 'package:example/modules/user/find_user.dart';
import 'package:get_server/get_server.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.USER, page: AddUser(), method: Method.post),
    GetPage(name: Routes.USER, page: FindUser(), method: Method.get),
  ];
}
