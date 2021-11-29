import 'package:tecnoanjostec/app/utils/object/object_utils.dart';

class TablePayment {
  int id;
  int userId;
  String name;

  double money;

  TablePayment({this.id, this.userId, this.name, this.money});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
    };
  }

  static TablePayment fromMap(Map<String, dynamic> map) {
    return new TablePayment(
      id: ObjectUtils.parseToInt(map['id'].toString()),
      userId: ObjectUtils.parseToInt(map['userId'].toString()),
      name: map['name'] as String,
      money: ObjectUtils.parseToDouble(map['money']),
    );
  }
}
