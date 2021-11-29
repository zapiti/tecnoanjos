class MyConversation {
  bool isMe = true;
  String role;
  String text;
  int received;
  String dataSend;

  String id;
  String date;
  String image;
  String room;
  String name;
  static const server = "SERVER";

  static const appMaker = 'Usuario';

  MyConversation(
      {this.isMe,
      this.role,
      this.text,
      this.received,
      this.id,
      this.date,
      this.image,
      this.room,
      this.name});

  factory MyConversation.fromMap(Map<String, dynamic> map) {
    if (map['role'] == appMaker) {}
    try {
      return new MyConversation(
        name: map['name'],
        id: map['id'].toString(),
        isMe: map['role'] == appMaker,
        role: map['role'] as String,
        text: map['text'] as String,
        room: map['room'] as String,
        image: map['image'] as String,
        received: 1,
      );
    } catch (e) {
      return null;
    }
  }

  factory MyConversation.fromMapText(String text, String room) {
    try {
      return new MyConversation(
        isMe: true,
        role: MyConversation.appMaker,
        text: text,
        room: room,
        received: 0,
        id: "1",
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMapText() {
    return {
      "text": this.text,
      "role": MyConversation.appMaker,
      'room': this.room,
    };
  }
}
