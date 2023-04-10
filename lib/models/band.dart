
class Band{

  String id;
  String nameProduct;
  String nameTable;
  int votes;
  int? votes2;

  Band({
    required this.id,
    required this.nameProduct,
    required this.nameTable,
    required this.votes,
    this.votes2
  });

  factory Band.fromMap(Map<String, dynamic> obj)
  =>  Band(
    id         : obj.containsKey('id')        ? obj['id']        : 'no-id',
    nameProduct       : obj.containsKey('nameProduct')      ? obj['nameProduct']      : 'no-nameProduct',
    nameTable  : obj.containsKey('nameTable') ? obj['nameTable'] : 'no-nameTable',
    votes      : obj.containsKey('votes')     ? obj['votes']     : 'no-votes',
    votes2      : obj.containsKey('votes2')     ? obj['votes2']     : 'no-votes2'
  );
}