

class ServiceProd {
  int id;
  String name;
  double price;
  bool selected = false;
  String type;
 static const HYBRID = "hybrid";
  static const REMOTE ="remote";
  static const PRESENTIAL ="presential";
  ServiceProd({this.id, this.name, this.price, this.selected, this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'selected': selected,
      'type': type,
    };
  }

  factory ServiceProd.fromMap(dynamic map) {
    if (null == map) return null;

    if (map is int) return null;
    var temp;
    return ServiceProd(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      name: map['name']?.toString(),
      price: null == (temp = map['price'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
      selected: null == (temp = map['selected'])
          ? null
          : (temp is bool
          ? temp
          : (temp is num
          ? 0 != temp.toInt()
          : ('true' == temp.toString()))),
      type: map['type']?.toString(),
    );
  }

}
