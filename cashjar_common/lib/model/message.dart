class Message {
  String id;
  final String senderId;
  DateTime sentOn;
  final String type;
  final String text;
  String url;
  final String filename;

  Message({this.id, this.senderId, this.sentOn, this.text, this.url, this.type, this.filename}) {
    this.sentOn = sentOn ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'senderId': this.senderId,
      'sentOn': this.sentOn,
      'text': this.text,
      'type': this.type,
      'url': this.url,
      'filename': this.filename,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      sentOn: map['sentOn'],
      text: map['text'],
      type: map['type'],
      url: map['url'],
      filename: map['filename'],
    );
  }
}