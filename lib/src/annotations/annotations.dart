class Table {
  final String name;

  const Table({this.name});
}

const table = Table();

// Houve falha ao retorna objeto com o nome diferente do atributo
/* class Column {
  final String name;
  const Column({this.name});
}

const column = Column(); */

class Id {
  final bool autoIncrement;
  //final bool foreignId;

  //const Id({this.autoIncrement = true, this.foreignId = false});
  const Id({this.autoIncrement = true});
}

const id = Id();

class ForeignId {
  const ForeignId();
}

const foreignId = ForeignId();

class NotNull {
  const NotNull();
}

const notNull = NotNull();

class ForeignTable {
  final String name;

  const ForeignTable({this.name});
}

const foreignTable = ForeignTable();
