class Table {
  final String name;
  const Table({this.name});
}

class Column {
  final String name;
  const Column({this.name});
}

class Id {
  final bool autoIncrement;
  const Id({this.autoIncrement = true});
}

class NotNull {
  const NotNull();
}
