class MessageModel {
  final String text;
  final bool isSender;
  final DateTime time;

  MessageModel({
    required this.text,
    required this.isSender,
    required this.time,
  });
}
