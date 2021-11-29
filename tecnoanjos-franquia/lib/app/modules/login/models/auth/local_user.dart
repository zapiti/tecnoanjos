class LocalUser {
  // static const ADMIN = "ADMIN"; //adminiastror
  // static var USER = "USER"; //usuario simples

  String id;
  String name;
  String email;
  String cpf;
  String rg;
  String telephone;
  String birthday;
  bool active;
  String provider;
  String blingId;
  String customer_id;

  factory LocalUser.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return LocalUser(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      email: map['email']?.toString(),
      cpf: map['cpf']?.toString(),
      rg: map['rg']?.toString(),
      telephone: map['telephone']?.toString(),
      birthday: map['birthday']?.toString(),
      active: null == (temp = map['active'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      provider: map['provider']?.toString(),
      blingId: map['blingId']?.toString(),
      customer_id: map['customer_id']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'rg': rg,
      'telephone': telephone,
      'birthday': birthday,
      'active': active,
      'provider': provider,
      'blingId': blingId,
      'customer_id': customer_id,
    };
  }

  LocalUser({
      this.id,
      this.name,
      this.email,
      this.cpf,
      this.rg,
      this.telephone,
      this.birthday,
      this.active,
      this.provider,
      this.blingId,
      this.customer_id});
}
