class ClientWallet {
  int id;
  String email;
  String name;
  String telephone;
  String imagemUrl;
  String tagTechnician;
  int walletId;

  ClientWallet(
      {this.walletId,
      this.id,
      this.email,
      this.name,
      this.telephone,
      this.imagemUrl,
      this.tagTechnician});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'name': this.name,
      'telephone': this.telephone,
      'imagemUrl': this.imagemUrl,
      'tagTechnician': this.tagTechnician,
    };
  }

  factory ClientWallet.fromMap(dynamic list) {
    var map = (list is List) ? list.first : list;
    if (map == null) {
      return null;
    }
    if (map["technician"] != null) {
      return new ClientWallet(
        walletId: map['id'] as int,
        id: map["technician"]['id'] as int,
        tagTechnician: map["tagTechnician"] as String,
        email: map["technician"]['email'] as String,
        name: map["technician"]['name'] as String,
        telephone: map["technician"]['telephone'] as String,
        imagemUrl: map["technician"]['pathImage'] as String,
      );
    } else {
      if (map["client"] != null) {
        return new ClientWallet(
          walletId: map['id'] as int,
          id: map["client"]['id'] as int,
          tagTechnician: map["tagTechnician"] as String,
          email: map["client"]['email'] as String,
          name: map["client"]['name'] as String,
          telephone: map["client"]['telephone'] as String,
          imagemUrl: map["client"]['imagemUrl'] as String,
        );
      } else {
        return new ClientWallet(
          walletId: map['id'] as int,
          tagTechnician: map["tagTechnician"] as String,
        );
      }
    }
  }
}
