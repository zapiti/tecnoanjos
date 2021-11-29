

class MyNotification {
  String id;
  String description;
  String title;
  String dtCreate;
  bool read = false;

  bool delete = false;

  MyNotification(
      {this.id,
      this.description,
      this.title,
      this.dtCreate,
      this.read = false,
      this.delete = false});

  static List fromListMap(Map map) {
    if (null == map) return null;
    var temp;
    return null == (temp = map['list'])
        ? []
        : (temp is List
            ? temp
                .map<MyNotification>((map) => MyNotification.fromMap(map))
                .toList()
            : []);
  }

  static Map<String, dynamic> toListMap(List list) {
    return {
      'list': list?.map((map) => map?.toMap())?.toList() ?? [],
    };
  }

  factory MyNotification.fromMap(dynamic map, {id}) {
    if (null == map) return null;
    var temp;
    return MyNotification(
      id:(id ?? (null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)))),
      description: map['description']?.toString(),
      title: map['title']?.toString(),
      dtCreate: map['dtCreate']?.toString(),
      read: null == (temp = map['read'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      delete: null == (temp = map['delete'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'title': title,
      'dtCreate': dtCreate,
      'read': read,
      'delete': delete,
    };
  }
}
