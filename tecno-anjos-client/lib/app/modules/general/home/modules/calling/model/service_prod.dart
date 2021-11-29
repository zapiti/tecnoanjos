

class ServiceProd {
  int id;
  String name;
  String description;
  double price;
  bool selected ;
  String type;
 static const HYBRID = "hybrid";
  static const REMOTE ="remote";
  static const PRESENTIAL ="presential";
  ServiceProd({this.id, this.name, this.price, this.selected= false, this.type,this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'selected': selected,
      'type': type,
      'description' :description
    };
  }

  factory ServiceProd.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return ServiceProd(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      name: map['name']?.toString(),
      description: map['description']?.toString() ?? "sem descrição",
      price: null == (temp = map['price'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),

      type: map['type']?.toString(),
    );
  }

}
