import 'package:tecnoanjos_franquia/app/utils/utils.dart';


class MyAddress {
  int id;

  String myAddress;
  String num;
  String neighborhood;
  String postal;
  String latitude;
  String longitude;
  String complement;
  int codRegion;
  String nameRegion;

  String title;

  MyAddress(
      {this.id,
      this.myAddress,
      this.num,
      this.neighborhood,
      this.postal,
      this.latitude,
      this.longitude,
      this.complement,
      this.codRegion,
      this.nameRegion,
      this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'address': this.myAddress,
      'num': this.num,
      'neighborhood': this.neighborhood,
      'postal':Utils.removeMask(this.postal),
      'latitude': this.latitude,
      'longitude': this.longitude,
      'complement': this.complement,
      'codRegion': this.codRegion,
      'nameRegion': this.nameRegion,
      'title': this.title,
    };
  }

  factory MyAddress.fromMap(Map<String, dynamic> map) {
    if(map == null){
      return null;
    }
    return new MyAddress(
      id: map['id'] as int,
      myAddress: map['address'] as String,
      num: map['num'] as String,
      neighborhood: map['neighborhood'] as String,
      postal: map['postal'] as String,
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
      complement: map['complement'] as String,
      codRegion: map['cityId'] as int,
      nameRegion: map['nameRegion'] as String,
      title: map['title'] as String,
    );
  }
}
