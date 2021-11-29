


class Teste {

  String id;


  Teste({this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  static Teste fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Teste(
      id: map['id']?.toString(),
    );
  }
}