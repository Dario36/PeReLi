class Item {
  final int? idItem;
  final String itemName;
  final String parent;
  final int isChecked;

  Item({this.idItem, required this.itemName, required this.parent, required this.isChecked});

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    idItem: json['idItem'],
    itemName: json['itemName'],
    parent: json['parent'],
    isChecked: json['isChecked']
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