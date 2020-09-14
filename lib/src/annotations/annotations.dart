class Table {
  final String name;
  const Table({this.name});
}

const table = Table();

class Column {
  final String name;
  const Column({this.name});
}

const column = Column();

class Id {
  final bool autoIncrement;
  const Id({this.autoIncrement = true});
}

const id = Id();

class NotNull {
  const NotNull();
}

const notNull = NotNull();
