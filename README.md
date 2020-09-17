# ORM_MYSQL DART
This is an attempt to develop an ORM in dart, I haven't seen any yet ...
** is an alpha version use only in tests do not use in production **
## First steps
- add the dependency in your pubspec.yaml

```yaml
dependencies:
    orm_mysql: 
        git: https://github.com/CpdnCristiano/orm_mysql.git
```
- Create your model class
```dart
//The table Annotation indicates to be a table in mysql
//NOTE: You can add a different class name to your table
//@Table (name: 'table_user')
@Table()
class User {
  // the tables must have an id, this is the indication of the mysql primary key
   // NOTE: By default the id is auto increment.
   // to change this do: @Id (autoIncrement: false)
  @Id()
  int id;
  // this annotation indicates that this column cannot be null in your database
  @NotNull()
  String name;

  int age;

  String email;

  User({this.id, this.name, this.age, this.email});
// it is necessary to have a fromJson constructor for the orm to work  
User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    email = json['email'];
  }
// it is necessary to have a toJson function for the orm to work
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['email'] = this.email;
    return data;
  }
```
- Create your repository:
```dart
// NOTE: the First parameter is your model class
// the second is the type of id in case an int
class UserRepository extends Repository<User, int> {}
```
in the repository there are the following methods
- findOne(id);
fetch object by id;
- finAll();
return all table objects.
- deleteOne(id);
delete an object
- insert(object)
creates a new object
- update(id, object) 
updates an object
#### start the database connection to the database

in main.dart
```dart
void main() async {
  MySQL db = MySQL(
    host: "localhost",
    user: "admin",
    password: "1234",
    db: "teste",
  );
  await db.init();
```
#### TODO:
- Custom query
- Foreign key support(1:1,N:N,1:N)

observations: In the future, the ORM will have a relationship between the wait

###### Example projects
[User registration API](https://github.com/CpdnCristiano/orm_mysql/tree/master/example)