class MessageModel {
  final String text;
  final bool isSender;
  final DateTime time;

  MessageModel({
    required this.text,
    required this.isSender,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {'text': text, 'isSender': isSender, 'time': time.toIso8601String()};
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      isSender: json['isSender'],
      time: DateTime.parse(json['time']),
    );
  }
}
