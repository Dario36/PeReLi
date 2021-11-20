/* Class for the Lists on the MainPage
* including methods to map the values, to interact with the database
 */

class RemindingList {
  final int? id;
  final String name;

  RemindingList({this.id, required this.name});

  factory RemindingList.fromMap(Map<String, dynamic> json) => RemindingList(
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