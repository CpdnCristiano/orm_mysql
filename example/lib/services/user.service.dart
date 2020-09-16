import 'package:example/data/models/user.model.dart';
import 'package:example/data/repositorys/user.repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();
  Future<List<User>> findAll() async => await _userRepository.findAll();
  Future<User> findByID(int id) async => await _userRepository.findOne(id);
  Future<User> createUser(Map<String, dynamic> json) async =>
      await _userRepository.insert(User.fromJson(json));
}
