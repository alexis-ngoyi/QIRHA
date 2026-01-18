class DiscussionModel {
  String img;
  String time;
  String msg;
  int pending;
  String sender;
  bool isCommande;

  DiscussionModel(
      {required this.sender,
      required this.isCommande,
      required this.img,
      required this.time,
      required this.pending,
      required this.msg});
}
