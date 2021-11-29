class UserEntity {
  static final USERLOG = "USERLOG";
  static final KID = "KID";
  static var JSESSION = "JSESSION";
  static const USER = "USER";
  static const PASS = "PASS";
  static const REFRESH = "REFRESH";
  static const SERVERSELECTED = "SERVERSELECTED";
  static const INTERNALUSER = "INTERNALUSER";
  static const INTERNALPASS = "INTERNALPASS";
  String username;
  String password;

  Parceiro selectedParc;

  String nomeEmp;

  String email;
  bool ativo;

  String image;
  List listParc;



  UserEntity(
      {this.username,
      this.password,
      this.selectedParc,
      this.email,
      this.ativo,
      this.nomeEmp,
      this.image,
      this.listParc});

  Map<String, dynamic> toMap() {
    return {
      'nome': this.username,
      'selectedParc': this.selectedParc?.toMap(),
      'nomeEmp': this.nomeEmp,
      'email': this.email,
      'ativo': this.ativo,
      'image': this.image,
      'parceiro': this.listParc?.map((partner) {
        return partner?.toMap();
      })?.toList()
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    var partner = map['parceiro']?.map((partner) {
      return Parceiro.fromMap(partner);
    })?.toList();
    var partners = partner?.where((valor) => valor != null)?.toList();
    var selected = Parceiro.fromMap(map["selectedParc"]);
    return new UserEntity(
      username: map['nome'] as String,
      selectedParc: selected ?? partners?.first as Parceiro,
      nomeEmp: map['nomeEmp'] as String,
      email: map['email'] as String,
      ativo: map['ativo'] as bool,
      image: map['image'] as String,
      listParc: partners,
    );
  }
}

class Parceiro {
  int codParc;
  String nomeParc;
  String razaoSocial;
  String cnpj;
  String telefone;
  String email;
  int contato;
  int codUsu;
  List roles;

  Parceiro(
      {this.codParc,
      this.nomeParc,
      this.cnpj,
      this.contato,
      this.codUsu,
      this.roles,
      this.razaoSocial,
      this.telefone,
      this.email});

  Map<String, dynamic> toMap() {
    return {
      'codParc': this.codParc,
      'nomeParc': this.nomeParc,
      'cnpj': this.cnpj,
      'codContato': this.contato,
      'codUsu': this.codUsu,
      'razaoSocial': this.razaoSocial,
      'telefone': this.telefone,
      'emailParc': this.email,
      'roles': this.roles?.map((partner) {
        return partner?.toMap();
      })?.toList()
    };
  }

  factory Parceiro.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    var roles = map['roles']?.map((role) {
      return Role?.fromMap(role);
    })?.toList();
    var allRoles = roles?.where((valor) => valor != null)?.toList();

    return new Parceiro(
        codParc: double.parse(map['codParc']?.toString() ?? "0").toInt(),
        nomeParc: map['nomeParc'] as String,
        cnpj: map['cnpj'] as String,
        telefone: map['telefone'] as String,
        razaoSocial: map['razaoSocial'] as String,
        contato: double.parse(map['codContato']?.toString() ?? "0").toInt(),
        email: map['emailParc'] as String,
        codUsu: double.parse(map['codUsu']?.toString() ?? "0").toInt(),
        roles: allRoles);
  }
}

class Role {
  String role_financeiro;
  String role_boleto;
  String role_notaFiscal;
  String role_pedidos;
  String role_detalhamentoPedido;
  String role_admPortal;
  String role_ordemServico;

  Role(
      {this.role_financeiro,
      this.role_boleto,
      this.role_notaFiscal,
      this.role_pedidos,
      this.role_detalhamentoPedido,
      this.role_admPortal,
      this.role_ordemServico});

  Map<String, dynamic> toMap() {
    return {
      'role_financeiro': this.role_financeiro,
      'role_boleto': this.role_boleto,
      'role_notaFiscal': this.role_notaFiscal,
      'role_pedidos': this.role_pedidos,
      'role_detalhamentoPedido': this.role_detalhamentoPedido,
      'role_admPortal': this.role_admPortal,
      'role_ordemServico': this.role_ordemServico
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return new Role(
      role_financeiro: map['role_financeiro'] as String,
      role_boleto: map['role_boleto'] as String,
      role_notaFiscal: map['role_notaFiscal'] as String,
      role_pedidos: map['role_pedidos'] as String,
      role_detalhamentoPedido: map['role_detalhamentoPedido'] as String,
      role_admPortal: map['role_admPortal'] as String,
      role_ordemServico: map['role_ordemServico'] as String,
    );
  }
}
