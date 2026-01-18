class MessageModel {
  String img;
  String time;
  String msg;
  bool isPending;
  String user;
  bool inbox;

  MessageModel(
      {required this.user,
      required this.img,
      required this.inbox,
      required this.time,
      required this.isPending,
      required this.msg});
}
