import 'package:example/modules/user/add_user.dart';
import 'package:example/modules/user/delete_user.dart';
import 'package:example/modules/user/find_user.dart';
import 'package:example/modules/user/update_user.dart';
import 'package:get_server/get_server.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.USER, page: AddUser(), method: Method.post),
    GetPage(name: Routes.USER, page: FindUser(), method: Method.get),
    GetPage(name: Routes.USER, page: DeleteUser(), method: Method.delete),
    GetPage(name: Routes.USER, page: UpdateUser(), method: Method.put),
  ];
}
