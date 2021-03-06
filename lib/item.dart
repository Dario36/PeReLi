/* Class for the checkable items on the RemindingListPage
* including methods to map the values, to interact with the database
 */

class Item {
  final int? idItem;
  final String itemName;
  final String parent;
  final bool isChecked;
  bool? itemBool = false;

  Item(
      {this.idItem,
      required this.itemName,
      required this.parent,
      required this.isChecked});

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        idItem: json['idItem'],
        itemName: json['itemName'],
        parent: json['parent'],
        isChecked: json['isChecked'] == 1,
      );

  Map<String, dynamic> toMap() {
    return {
      'idItem': idItem,
      'itemName': itemName,
      'parent': parent,
      'isChecked': isChecked
    };
  }
}
