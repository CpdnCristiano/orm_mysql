import 'dart:async';

import 'package:example/exceptions/api_exception.dart';
import 'package:example/services/user.service.dart';
import 'package:example/widgets/error_widget.dart';
import 'package:get_server/get_server.dart';

class UpdateUser extends GetView {
  UserService userService = UserService();

  @override
  FutureOr<Widget> build(Context context) async {
    try {
      String id = context.param('id');
      if (id == null) {
        return ErrorWidget('user id if deleted was not passed', 400);
      } else {
        int id = int.parse(context.param('id'));
        Map<String, dynamic> json = await context.payload();
        return Json(await userService.updateUser(id, json));
      }
    } on NoSuchMethodError catch (_) {
      //throw ApiException('erro', 400);
      return ErrorWidget('request body is invalid', 400);
    } on FormatException catch (_) {
      return ErrorWidget('the id parameter entered is not of type int', 400);
    } on ApiException catch (e) {
      return ErrorWidget(e.message, e.code);
    } catch (e) {
      print(e);
      return ErrorWidget('an unexpected error occurred', 500);
    }
  }
}
