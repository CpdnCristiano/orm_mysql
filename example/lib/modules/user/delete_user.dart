import 'dart:async';

import 'package:example/services/user.service.dart';
import 'package:example/widgets/error_widget.dart';
import 'package:get_server/get_server.dart';

class DeleteUser extends GetView {
  UserService userService = UserService();

  @override
  FutureOr<Widget> build(Context context) async {
    try {
      String id = context.param('id');
      if (id == null) {
        return ErrorWidget('user id if deleted was not passed', 400);
      } else {
        int id = int.parse(context.param('id'));
        await userService.deleteUser(id);
        context.response.status(200);
        return Text('');
      }
    } on FormatException catch (_) {
      return ErrorWidget('the id parameter entered is not of type int', 400);
    } catch (e) {
      print(e);
      return ErrorWidget('an unexpected error occurred', 500);
    }
  }
}
