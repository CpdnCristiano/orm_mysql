import 'package:orm_mysql/orm_mysql.dart';

@table
class User {
  @Id()
  int id;
  String name;
  int age;
  String email;
  bool isActive;

  User({this.id, this.name, this.age, this.email, this.isActive});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    email = json['email'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['email'] = email;
    data['isActive'] = isActive;
    return data;
  }
}
