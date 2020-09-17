import 'dart:async';

import 'package:example/services/user.service.dart';
import 'package:example/widgets/error_widget.dart';
import 'package:get_server/get_server.dart';

class FindUser extends GetView {
  UserService userService = UserService();
  @override
  FutureOr<Widget> build(Context context) async {
    try {
      String id = context.param('id');
      if (id == null) {
        return Json(await userService.findAll());
      } else {
        int id = int.parse(context.param('id'));
        var user = await userService.findByID(id);
        if (user == null) {
          context.response.status(404);
          return Json({});
        }
        return Json(user);
      }
    } on FormatException catch (_) {
      return ErrorWidget('the id parameter entered is not of type int', 400);
    } catch (e) {
      print(e);
      return ErrorWidget('an unexpected error occurred', 500);
    }
  }
}
