import 'package:get_server/get_server.dart';

class ErrorWidget extends GetWidget {
  String message;
  int code;
  ErrorWidget(this.message, this.code);
  @override
  Future build(Context context) {
    return context.response
        .status(code)
        .sendJson({'code': code, 'message': message});
  }
}
