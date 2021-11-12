class RemindingList {
  final int? id;
  final String name;

  RemindingList({this.id, required this.name});

  factory RemindingList.fromMap(Map<String, dynamic> json) => new RemindingList(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}