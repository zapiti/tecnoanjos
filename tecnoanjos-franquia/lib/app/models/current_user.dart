
class CurrentUser {
  int id;
  bool isFirstLogin;
  int iat;
  int exp;
  String name;
  String imageUrl;
  String telephone;

  static String FUNCIONARY = "FUNCIONARY";
  static String FRANCHISE = "FRANCHISE";

  CurrentUser(
      {this.id,
        this.isFirstLogin,
        this.iat,
        this.exp,
        this.name,
        this.imageUrl,this.telephone});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'isFirstLogin': this.isFirstLogin,
      'iat': this.iat,
      'exp': this.exp,
      'name': this.name,
      'imageUrl': this.imageUrl,
      'telephone':this.telephone
    };
  }

  factory CurrentUser.fromMap( map) {
    return new CurrentUser(
      id: map['id'] as int,
      isFirstLogin: map['isFirstLogin'] as bool,
      iat: map['iat'] as int,
      exp: map['exp'] as int,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      telephone: map['telephone'] as String,
    );
  }
}
