part of 'repository.dart';

String _getTableName(ClassMirror cm) {
  String tablename;
  cm.metadata.forEach((meta) {
    if (meta.reflectee is Table) {
      tablename = meta.reflectee.name ?? MirrorSystem.getName(cm.simpleName);
    }
  });
  if (tablename == null) {
    throw Exception('annotations @Table not found in ${cm.location} ');
  }
  return ReCase(tablename).snakeCase;
}

String _getColumnName(VariableMirror vm) {
  //print(vm.metadata);
  String columnName = MirrorSystem.getName(vm.simpleName);
  /* vm.metadata.forEach((meta) {
    if (meta.reflectee is Column) {
      columnName = meta.reflectee.name ?? MirrorSystem.getName(vm.simpleName);
    }
  });
 */

  //mudando para contar _ para duas palvras no sql
  return ReCase(columnName).snakeCase;
}

String _createTableFromObject(Type classe) {
  String query = '';
  ClassMirror cm = reflectClass(classe);
  String tablename = _getTableName(cm);
  _getPrimaryKey(cm);

  //TODO : livrar coluna com ForeignTable
  cm.metadata.forEach((meta) {
    if (meta.reflectee is Table) {
      query += 'CREATE TABLE IF NOT EXISTS $tablename (';
      cm.declarations.forEach((key, value) {
        if (!value.isPrivate) {
          if (!(value is MethodMirror)) {
            VariableMirror vm = cm.declarations[key];
            vm.metadata.forEach((meta) {
              if (!(meta.reflectee is ForeignTable)) {
                if (query.endsWith('(')) {
                  query += '\n ${_processColunm(vm)}';
                } else {
                  query += ',\n ${_processColunm(vm)}';
                }
              }
            });
          }
        }
      });

      query += '\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
    }
  });
  return query;
}

//TODO : adicionado FOREIGN
String _processColunm(VariableMirror vm) {
  String column = _getColumnName(vm);
  column += ' ';
  column += getSqlType(vm.type.reflectedType.toString());
  vm.metadata.forEach((meta) {
    if (meta.reflectee is Id) {
      column += ' PRIMARY KEY AUTO_INCREMENT NOT NULL';
    } else if (meta.reflectee is ForeignId) {
      column += ' FOREIGN KEY REFERENCES';
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
//TODO : pegando ForeignId das classes ForeignTable
List<ForeignTableInner> _getForeignKeys(ClassMirror cm, Type T) {
  var foreignkey = <ForeignTableInner>[];
  cm.metadata.forEach((meta) {
    if (meta.reflectee is Table) {
      cm.declarations.forEach((key, value) {
        if (!value.isPrivate) {
          if (!(value is MethodMirror)) {
            VariableMirror vm = cm.declarations[key];
            vm.metadata.forEach((meta) {
              if (meta.reflectee is ForeignTable) {
                ClassMirror cmInner = reflectClass(vm.type.reflectedType);

                cmInner.metadata.forEach((metaInner) {
                  if (metaInner.reflectee is Table) {
                    cmInner.declarations.forEach((key, value) {
                      if (!value.isPrivate) {
                        if (!(value is MethodMirror)) {
                          if (metaInner.reflectee is ForeignId) {
                            //foreignkey.add(_getColumnName(vm));
                            VariableMirror vmInner = cmInner.declarations[key];
                            foreignkey.add(ForeignTableInner(
                                name: _getColumnName(vm),
                                foreignId: _getColumnName(vmInner)));
                          }
                        }
                      }
                    });
                  }
                });
              }
            });
          }
        }
      });
    }
  });

  if (foreignkey.isEmpty) {
    throw Exception('Annotations @ForeignId not found in ${cm.location} ');
  }

  return foreignkey;
}

void _replaceBoolInt(ClassMirror cm, Map<String, dynamic> data) {
  cm.declarations.forEach((key, value) {
    if (!value.isPrivate) {
      if (value is VariableMirror) {
        if (value.type.reflectedType.toString() == 'bool') {
          data.update(ReCase(_getColumnName(value)).snakeCase, (value) {
            return value == 1;
          });
        }
      }
    }
  });
}
