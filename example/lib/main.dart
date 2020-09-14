import 'package:example/config.dart';
import 'package:orm_mysql/orm_mysql.dart';

void main() async {
  MySQL db = MySQL(
    host: Config.host,
    user: Config.user,
    password: Config.password,
    db: Config.db,
  );
  await db.init();
  UserRepository repository = UserRepository();
  List<User> allUser = await repository.findAll();

  print('Printando todos os usuários');
  allUser.forEach((user) {
    print(user.toJson());
    print('\n');
  });

  print('Printando o usuário de id = 1');
  User user = await repository.findOne(1);
  if (user != null) {
    print(user.toJson());
  }

  await repository.insert(
      User(name: 'Cristiano', age: 19, email: 'CpdnCristiano@gmail.com'));
  await db.close();
}

@Table()
class User {
  @Id(autoIncrement: true)
  int id;

  @NotNull()
  String name;

  int age;

  String email;

  User({this.id, this.name, this.age, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['email'] = email;
    return data;
  }
}

class UserRepository extends Repository<User, int> {}
