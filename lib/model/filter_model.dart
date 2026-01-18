class FilterModel {
  int? id;
  String? label;

  FilterModel({this.id, this.label});
}

class FilterModelGroup {
  List<FilterModel> list;

  FilterModelGroup({required this.list});
}
