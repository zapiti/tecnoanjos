

class Heaven {
  String nameTecnoanjo;//vem do usuario que criou
  String imageTecnoanjo;//vem do usuario que criou
  int idTecnoanjo;//vem do usuario que criou
  String status;//default p
  int id;
  String imageAdmin;//vem do update
  String nameAdmin;//vem do update
  int idAdmin;

  Heaven({this.nameTecnoanjo, this.imageTecnoanjo, this.idTecnoanjo, this.status,
    this.id, this.imageAdmin, this.nameAdmin, this.idAdmin});

  Map<String, dynamic> toMap() {
    return {
      'nameTecnoanjo': nameTecnoanjo,
      'imageTecnoanjo': imageTecnoanjo,
      'idTecnoanjo': idTecnoanjo,
      'status': status,
      'id': id,
      'imageAdmin': imageAdmin,
      'nameAdmin': nameAdmin,
      'idAdmin': idAdmin,
    };
  }

  factory Heaven.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Heaven(
      nameTecnoanjo: map['nameTecnoanjo']?.toString(),
      imageTecnoanjo: map['imageTecnoanjo']?.toString(),
      idTecnoanjo: null == (temp = map['idTecnoanjo'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      status: map['status']?.toString(),
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      imageAdmin: map['imageAdmin']?.toString(),
      nameAdmin: map['nameAdmin']?.toString(),
      idAdmin: null == (temp = map['idAdmin'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
    );
  }
}