import 'dart:async';

import 'package:example/widgets/error_widget.dart';
import 'package:get_server/get_server.dart';

class AddUser extends GetView {
  @override
  FutureOr<Widget> build(Context context) async {
    try {
      Map<String, dynamic> json = await context.payload();
      return Json(json);
    } on NoSuchMethodError catch (e) {
      //throw ApiException('erro', 400);
      return ErrorWidget('request body is invalid', 400);
    } catch (e) {
      return ErrorWidget('an unexpected error occurred', 500);
    }
  }
}
