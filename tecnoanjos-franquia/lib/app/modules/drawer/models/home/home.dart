class Home {
  final String name;
  final String url;
  List employers = [];
  String searchString;
  bool permission;
  String selectedHome;

  Home(
      {this.name,
      this.url,
      this.employers,
      this.permission,
      this.selectedHome});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'url': this.url,
      'employers': this.employers,
      'permission': this.permission,
      'searchString': this.searchString,
      'selectedHome': this.selectedHome,
    };
  }

  factory Home.fromMap(Map<String, dynamic> map) {
    return new Home(
      name: map['name'] as String,
      url: map['url'] as String,
      employers: map['employers'] as List,
      selectedHome: map['selectedHome'] as String,
      permission: map['permission'] as bool,
    );
  }
}
