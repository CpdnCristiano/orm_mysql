import 'package:example/data/models/user.model.dart';
import 'package:example/data/repositorys/user.repository.dart';
import 'package:example/exceptions/api_exception.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

  Future<List<User>> findAll() async => await _userRepository.findAll();

  Future<User> findByID(int id) async => await _userRepository.findOne(id);

  Future<User> createUser(Map<String, dynamic> json) async =>
      await _userRepository.insert(User.fromJson(json));

  Future<void> deleteUser(id) async => await _userRepository.deleteOne(id);

  Future<User> updateUser(int id, Map<String, dynamic> json) async {
    User userSave = await _userRepository.findOne(id);
    if (userSave == null) {
      throw ApiException('No user found with id $id', 404);
    }
    User newUser = User.fromJson(json);
    //newUser.id = userSave.id;

    //Do not allow changing id;
    newUser.id = id;

    //Update has null return for now
    await _userRepository.update(id, newUser);

    return await findByID(id);
  }
}
