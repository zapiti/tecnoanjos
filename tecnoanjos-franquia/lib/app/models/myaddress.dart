class MyAddress {
  String id;
  String name;
  String createdAt;
  String updatedAt;
  MyState state;

  MyAddress({this.id, this.name, this.createdAt, this.updatedAt, this.state});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'state': state?.toMap(),
    };
  }

  factory MyAddress.fromMap(dynamic map) {

    if (null == map) return null;
    var temp;
    return MyAddress(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      createdAt: map['createdAt']?.toString(),
      updatedAt: map['updatedAt']?.toString(),
      state: MyState.fromMap(map['state']),
    );
  }

  toRegion() {
    return {"city": name, "uf": state.name};
  }
}

class MyState {
  int id;
  String name;
  String initials;
  String createdAt;
  String updatedAt;

  MyState({this.id, this.name, this.initials, this.createdAt, this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'initials': initials,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory MyState.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return MyState(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      name: map['name']?.toString(),
      initials: map['initials']?.toString(),
      createdAt: map['createdAt']?.toString(),
      updatedAt: map['updatedAt']?.toString(),
    );
  }
}
