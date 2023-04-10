
class Tabe{

  String id;
  String tableName;
  String color;

  Tabe({
    required this.id,
    required this.tableName,
    required this.color
  });

  factory Tabe.fromMap(Map<String, dynamic> obj)
  =>  Tabe(
    id         : obj.containsKey('id')        ? obj['id']        : 'no-id',
    tableName  : obj.containsKey('tableName') ? obj['tableName'] : 'no-tableName',
    color      : obj.containsKey('color')     ? obj['color']     : 'Colors.cyan',
  );
}