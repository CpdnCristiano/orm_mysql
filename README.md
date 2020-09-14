readme em português por enquanto
# ORM_MYSQL DART
Essa é uma tentativa de desenvolver uma ORM em dart, ainda não vi nenhum...
**é uma versão alpha use apenas em testes não use em produção**
## Primeiros passos
- adicionr a dependência no seu pubspec.yaml
```yaml
dependencies:
    orm_mysql: 
        git: ../
```
- Cria sua classe model
```dart
// A Anotacão table indica ser uma tabela no mysql
// NOTA: Você pode adicionar um nome diferete da classe na sua tabela
// @Table(name: 'tabela_user')
@Table()
class User {
  // as tabela deve ter um id, isso é a indicacão do primary key do mysql
  // NOTA: Por padrão o id é auto increment.
  // para alterar isso faça: @Id(autoIncrement: false)
  @Id()
  int id;
  // essa anotação indicar que essa coluna nao pode ficar nula mo seu banco de dados
  @NotNull()
  String name;

  int age;

  String email;

  User({this.id, this.name, this.age, this.email});
  // é necessario ter um contrutor fromJson para que o orm funcione
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['email'] = this.email;
    return data;
  }
```
- Crie seu repositório:
```dart
//NOTA: o Primeiro parametro é sua classe model
// o segundo é o tipo do id no caso um int
class UserRepository extends Repository<User, int> {}
```
nos repositorio exite os seguintes métodos
- findOne(id);
buscar objeto por id;
- finAll(); 
retornar todos as objeto da tabela.
- delete(id);
apagar um objeto
- insert(object)
apagar um objeto

#### inicar o banco conexão com o banco de dodos
no main.dart
```dart
void main() async {
  MySQL db = MySQL(
    host: "localhost",
    user: "admin",
    password: "1234",
    db: "teste",
  );
  await db.init();

#### TODO:
- Update
- Custom query
- Suporte para Foreign key
