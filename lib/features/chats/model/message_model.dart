// ignore_for_file: public_member_api_docs, sort_constructors_first

class Message {
  final String senderId;
  final String receiverId;
  final DateTime timeSent;
  final String messageId;
  final String text;
  Message({
    required this.senderId,
    required this.receiverId,
    required this.timeSent,
    required this.messageId,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'text': text,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      messageId: map['messageId'] as String,
      text: map['text'] as String,
    );
  }
}
