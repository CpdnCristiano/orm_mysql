import 'dart:mirrors';

import 'package:orm_mysql/src/annotations/annotations.dart';
import 'package:orm_mysql/src/mysql/db.dart';

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
      InstanceMirror res = cm.newInstance(#fromJson, [element.fields]);
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
      InstanceMirror res = cm.newInstance(#fromJson, [data.single.fields]);
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
    Map<String, dynamic> map = res.invoke(#toJson, []).reflectee;
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
}

String _getTableName(ClassMirror cm) {
  String tablename;
  cm.metadata.forEach((meta) {
    if (meta.reflectee is Table) {
      tablename = meta.reflectee.name ??
          MirrorSystem.getName(cm.simpleName).toLowerCase();
    }
  });
  if (tablename == null) {
    throw Exception('annotations @Table not found in ${cm.location} ');
  }
  return tablename;
}

String _getColumnName(VariableMirror vm) {
  //print(vm.metadata);
  String columnName = MirrorSystem.getName(vm.simpleName).toLowerCase();
  vm.metadata.forEach((meta) {
    if (meta.reflectee is Column) {
      columnName = meta.reflectee.name ??
          MirrorSystem.getName(vm.simpleName).toLowerCase();
    }
  });
  return columnName;
}

String _createTableFromObject(Type classe) {
  String query = '';
  ClassMirror cm = reflectClass(classe);
  String tablename = _getTableName(cm);
  _getPrimaryKey(cm);

  cm.metadata.forEach((meta) {
    if (meta.reflectee is Table) {
      query += 'CREATE TABLE IF NOT EXISTS $tablename (';
      cm.declarations.forEach((key, value) {
        if (!value.isPrivate) {
          if (!(value is MethodMirror)) {
            VariableMirror vm = cm.declarations[key];
            if (query.endsWith('(')) {
              query += '\n ${_processColunm(vm)}';
            } else {
              query += ',\n ${_processColunm(vm)}';
            }
          }
        }
      });

      query += '\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
    }
  });
  return query;
}

String _processColunm(VariableMirror vm) {
  String column = _getColumnName(vm);
  column += ' ';
  column += getSqlType(vm.type.reflectedType.toString());
  vm.metadata.forEach((meta) {
    if (meta.reflectee is Id) {
      column += ' PRIMARY KEY AUTO_INCREMENT NOT NULL';
    } else if (meta.reflectee is NotNull) {
      column += ' NOT NULL';
    }
    ;
  });

  return column;
}

String getSqlType(String dartType) {
  if (dartType == 'String') {
    return 'VARCHAR(255)';
  } else if (dartType == 'int') {
    return 'INT';
  } else if (dartType == 'bool') {
    return 'BOOLEAN';
  } else {
    return dartType;
  }
}

String _getPrimaryKey(ClassMirror cm) {
  String primarykey;
  int primarykeys = 0;
  cm.metadata.forEach((meta) {
    if (meta.reflectee is Table) {
      cm.declarations.forEach((key, value) {
        if (!value.isPrivate) {
          if (!(value is MethodMirror)) {
            VariableMirror vm = cm.declarations[key];
            vm.metadata.forEach((meta) {
              if (meta.reflectee is Id) {
                primarykey = _getColumnName(vm);
                primarykeys++;
              }
            });
          }
        }
      });
    }
  });
  if (primarykey == null) {
    throw Exception('Annotations @Id not found in ${cm.location} ');
  }
  if (primarykeys > 1) {
    throw Exception('More than one @id was entered in the ${cm.location} ');
  }
  return primarykey;
}
