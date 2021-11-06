class RemindingListItem {
  bool isChecked = false;
  String itemName = "";
  int index = 0;
  RemindingListItem(String s) {
    itemName = s;
  }
  void updateItem() {
    if(isChecked==false) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }
}