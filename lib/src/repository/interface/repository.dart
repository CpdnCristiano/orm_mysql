import 'dart:mirrors';

import 'package:orm_mysql/src/annotations/annotations.dart';
import 'package:orm_mysql/src/mysql/db.dart';
import 'package:recase/recase.dart';
import 'package:sql_recase/sql_recase.dart';
part 'functions_repository.dart';

// Example: UserRepository extends Repository<User, int>
// Note: First parameter is the class model, and the second is the type of id
abstract class Repository<T, S> {
  Repository() {
    MySQL.connection.query(_createTableFromObject(T));
  }

  Future<List<T>> findAll() async {
    ClassMirror cm = reflectClass(T);
    String tablename = _getTableName(cm);
    var data = await MySQL.connection.query('SELECT * FROM $tablename');
    List result = <T>[];
    data.forEach((element) {
      _replaceBoolInt(cm, element.fields);
      InstanceMirror res = cm.newInstance(
          #fromJson, [recaseMap(element.fields, recaseKeyCamelCase)]);
      result.add(res.reflectee);
    });

    return result;
  }

  Future<T> findOne(S value) async {
    ClassMirror cm = reflectClass(T);
    String tablename = _getTableName(cm);
    String primaryKey = _getPrimaryKey(cm);
    var data = await MySQL.connection
        .query('SELECT * FROM $tablename WHERE $primaryKey = ?', [value]);

    if (data.isNotEmpty) {
      _replaceBoolInt(cm, data.single.fields);
      InstanceMirror res = cm.newInstance(
          #fromJson, [recaseMap(data.single.fields, recaseKeyCamelCase)]);
      return res.reflectee;
    }
    return null;
  }

  Future<void> deleteOne(S value) async {
    ClassMirror cm = reflectClass(T);
    String tablename = _getTableName(cm);
    String primaryKey = _getPrimaryKey(cm);
    return await MySQL.connection
        .query('DELETE FROM $tablename WHERE $primaryKey = ?', [value]);
  }

  Future<void> insert(T value) async {
    InstanceMirror res = reflect(value);
    ClassMirror cm = reflectClass(T);
    String tablename = _getTableName(cm);
    Map<String, dynamic> map =
        recaseMap(res.invoke(#toJson, []).reflectee, recaseKeySnakeCase);
    List<String> keys = map.keys.toList();
    map.forEach((key, value) {
      if (value == null) keys.remove(key);
    });
    List<dynamic> values = [];

    map.values.forEach((v) {
      if (v != null) {
        if (v is String) {
          values.add('\"$v\"');
        } else {
          values.add(v);
        }
      }
    });
    /* cm.declarations.forEach((key, value) {
      if (!value.isPrivate) {
        if (!(value is MethodMirror)) {
          InstanceMirror vm = res.getField(key);
          print(vm.reflectee);
          if (vm.reflectee is String) {
            if (values.isEmpty) {
              values += '\"${vm.reflectee}\"';
            }
          } else {
            values += '\"${vm.reflectee}\"';
          }
        }
      }
    }); */

    return await MySQL.connection.query(
        'INSERT INTO `$tablename`(${keys.join(",")}) VALUES (${values.join(",")})');
  }

  void update(S id, T objet) async {
    ClassMirror cm = reflectClass(T);
    String tablename = _getTableName(cm);
    String primaryKey = _getPrimaryKey(cm);
    InstanceMirror res = reflect(objet);
    Map<String, dynamic> map =
        recaseMap(res.invoke(#toJson, []).reflectee, recaseKeySnakeCase);
    List<String> query = [];
    map.forEach((key, value) {
      if (value is String && value != null) {
        query.add('$key = "$value"');
      } else {
        query.add('$key = $value');
      }
    });
    await MySQL.connection.query(
        'UPDATE `$tablename` SET ${query.join(',')} WHERE $primaryKey = ?',
        [id]);
  }
}
