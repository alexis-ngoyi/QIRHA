// ignore_for_file: non_constant_identifier_names

class CategorieModel {
  String? img;
  String? libelle;
  String? categorie_id;

  CategorieModel({this.img, this.libelle, this.categorie_id});
  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      categorie_id: json['categorie_id'],
      img: json['img'],
      libelle: json['libelle'],
    );
  }
}

class GroupeCategorieModel {
  String? groupe;
  String? id;
  List<CategorieModel>? categorie;

  GroupeCategorieModel({this.groupe, this.categorie, this.id});
  factory GroupeCategorieModel.fromJson(Map<String, dynamic> json) {
    return GroupeCategorieModel(
      id: json['id'],
      groupe: json['groupe'],
      categorie: json['categorie'],
    );
  }
}
