class Faq {
  int id;
  String title;
  String description;
  String link;

  Faq({this.id, this.title, this.description, this.link});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'link': this.link,
    };
  }

  static Faq fromMap(Map<String, dynamic> map) {
    return new Faq(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      link: map['link'] as String,
    );
  }
}
