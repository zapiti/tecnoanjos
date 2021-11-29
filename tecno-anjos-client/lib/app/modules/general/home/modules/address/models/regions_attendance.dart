class RegionAttendance {
  int id;
  String title;
  String name;
  int stateId;
  String stateName;

  RegionAttendance(
      {this.id, this.title, this.name, this.stateId, this.stateName});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'name': this.name,
      'idState': this.stateId,
      'stateName': this.stateName
    };
  }

  static RegionAttendance fromMap(Map<String, dynamic> map) {
    return new RegionAttendance(
      id: map['id'] as int,
      title: map['title'] as String,
      name: map['name'] as String,
      stateId: map['stateId'] as int,
      stateName: map['stateName'] as String,
    );
  }
}
