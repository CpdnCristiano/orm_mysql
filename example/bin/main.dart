import 'package:example/config_exemple.dart';
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
  LivroRepository livroRepository = LivroRepository();

  await repository.insert(User(
      name: 'Cristiano',
      age: 19,
      email: 'CpdnCristiano@gmail.com',
      isActive: null));

  await livroRepository.insert(Livro(
      name: 'Renascer da Esperança',
      description: 'Livro de Romance',
      userId: 1,
      id: 1));

  List<User> allUser = await repository.findAll();

  print('Printando todos os usuários');
  allUser.forEach((user) {
    print(user.toJson());
    print('\n');
  });
  await repository.update(
      1,
      User(
          id: 1,
          name: 'Cristiano nascimento',
          age: 20,
          email: 'CpdnCristiano@gmail.com',
          isActive: true));

  print('Printando o usuário de id = 1');
  User user = await repository.findOne(1);
  if (user != null) {
    print(user.toJson());
  }

  await db.close();
}

@table
class User {
  @Id()
  int id;
  String name;
  int age;
  String email;
  bool isActive;
  @foreignTable
  Livro livro;

  User({this.id, this.name, this.age, this.email, this.isActive, this.livro});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    email = json['email'];
    isActive = json['isActive'];
    livro = json['livro'] == null ? null : Livro.fromJson(json['livro']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['email'] = email;
    data['isActive'] = isActive;
    data['livro'] = livro.toJson();
    return data;
  }
}

class UserRepository extends Repository<User, int> {}

@table
class Livro {
  @Id()
  int id;
  @foreignId
  int userId;
  String name;
  String description;

  Livro({this.id, this.userId, this.name, this.description});

  Livro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['description'] = description;

    return data;
  }
}

class LivroRepository extends Repository<Livro, int> {}
