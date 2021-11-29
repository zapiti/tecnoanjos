class CurrentUser {
  int id;
  bool isFirstLogin;
  int iat;
  int exp;
  String token;
  String email;
  String name;
  String imageUrl;
  String telephone;

  CurrentUser({this.id, this.isFirstLogin, this.iat, this.exp, this.token,
      this.email, this.name, this.imageUrl, this.telephone});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isFirstLogin': isFirstLogin,
      'iat': iat,
      'exp': exp,
      'token': token,
      'email': email,
      'name': name,
      'imageUrl': imageUrl,
      'telephone': telephone,
    };
  }

  factory CurrentUser.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return CurrentUser(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      isFirstLogin: null == (temp = map['isFirstLogin'])
          ? null
          : (temp is bool
              ? temp
              : (temp is num
                  ? 0 != temp.toInt()
                  : ('true' == temp.toString()))),
      iat: null == (temp = map['iat'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      exp: null == (temp = map['exp'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      token: map['token']?.toString(),
      email: map['email']?.toString(),
      name: map['name']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      telephone: map['telephone']?.toString(),
    );
  }
}
