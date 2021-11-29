class CurrentUser {
  int id;
  bool isFirstLogin;
  int iat;
  int exp;
  String tag;
  String telephone;
  String role;
  String name;
  String username;
  String password;

  static const USER = "USER";
  static const PASS = "PASS";
  static const USERLOG = "USERLOG";
  static const KID = "KID";
  static const REFRESH = "REFRESH";
  static const HOMEBASED = "HOMEBASED";
  static const MULTIFRANQUISE = "MULTIFRANQUISE";
  static const FUNCIONARY = "FUNCIONARY";
  static const QUIOSQUE = "QUIOSQUE";
  static const OFFICE = "OFFICE";
  static const CLIENT  = "CLIENT";

  CurrentUser({this.id, this.isFirstLogin, this.iat, this.exp, this.name,this.tag, this.role,this.telephone});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'isFirstLogin': this.isFirstLogin,
      'iat': this.iat,
      'exp': this.exp,
      'name': this.name,
      'tag':this.tag,'role':this.role, 'telephone':this.telephone
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return new CurrentUser(
      id: map['id'] as int,
      isFirstLogin: map['isFirstLogin'] as bool,
      iat: map['iat'] as int,
      exp: map['exp'] as int,
      tag: map['tag'] as String,
      name: map['name'] as String,
      role: map['role']?.toString() ?? FUNCIONARY,
      telephone: map['telephone'] as String,
    );
  }
}
