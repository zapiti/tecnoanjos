

class CurrentPerson {
  static const sistema = "CredParSistema";
  static const usuario = "CredParUsuario";
  String name;

  String phone;

  String email;



  String message = "<span class='$sistema' style='text-align: center;'>Solicito atendimento Credpar!</span>";
  String channel;

  CurrentPerson({this.name, this.phone, this.email});

  Map<String, dynamic> toMap() {
    return message == null
        ? {
            'name': name,
            'phone': phone,
            'email': email,
            'channel': channel,
          }
        : {
            'name': name,
            'phone': phone,
            'email': email,
            'message': message,
            'channel': channel,
          };
  }

  factory CurrentPerson.fromMap(dynamic map) {
    if (null == map) return null;

    return CurrentPerson(
      name: map['name']?.toString(),
      phone: map['phone']?.toString(),
      email: map['email']?.toString(),
    );
  }
}
