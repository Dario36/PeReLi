class Item {
  final int? idItem;
  final String itemName;
  final String parent;
  final bool isChecked;
  bool? itemBool = false;

  Item({this.idItem, required this.itemName, required this.parent, required this.isChecked});

  bool updateBool() {
    if(this.isChecked==0) {
      this.itemBool = false;
      return false;
    } else {
      this.itemBool=true;
      return true;
    }
  }

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    idItem: json['idItem'],
    itemName: json['itemName'],
    parent: json['parent'],
    isChecked: json['isChecked']==1,
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