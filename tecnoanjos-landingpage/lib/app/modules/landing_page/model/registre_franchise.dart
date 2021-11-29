

class RegisteFranchise {
  bool franquise = true;
  String nome;
  String contact;
  String role;

  String email;

  String telefone;

  String cnpj;

  String razaoSocial;




  RegisteFranchise({this.nome, this.contact, this.role,
      this.email, this.telefone, this.cnpj, this.razaoSocial});

  static final homebase = 'HOMEBASED';
  static final office = 'OFFICE';
  static final quiosque = 'QUIOSQUE';

  Map<String, dynamic> toMap() {
    return {

      'role':role == null ? franquise ? office:quiosque:role,
      'fantasyName': nome,
      'contact': contact,
      'email': email,
      'telephone': telefone,
      'cnpj': cnpj,
      'corporateName': razaoSocial ?? "Sem razao social",
      'address':  {
        "address": "Rua dos malucos",
        "codRegion": 1,
        "latitude": "99999",
        "longitude": "99999",
        "complement": "casa 99",
        "neighborhood": "Taiaman",
        "nameRegion": "Doidos",
        "num": "999",
        "postal": "34412-887",
        "title": "Doidos"
      }

      //address?.toMap(),
    };
  }
}