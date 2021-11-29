class Pairs {
  dynamic first;
  dynamic second;
  dynamic third;
  dynamic four;
  bool selected;

  Pairs(this.first, this.second, {this.third, this.selected, this.four});

  static Pairs fromMap(
    Map<String, dynamic> map,
  ) {
    return Pairs(map['key'], map['value'],
        third: map["apelido"], four: map["cor"]);
  }

  static FieldPairs fromMapList(List result) {
    return FieldPairs(result.map((e) => fromMap(e)).toList());
  }

  static Pairs fromMapEndereco(Map<String, dynamic> map) {
    return Pairs(map['codEndereco'].toString(), map['descricaoEnderecoEntrega'],
        third: map["nomeEndereco"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'first': this.first,
      'second': this.second,
      'third': this.third,
      'four': this.four,
      'selected': this.selected,
    };
  }

  factory Pairs.fromMap2(Map<String, dynamic> map) {
    return new Pairs(
      map['first'] as dynamic,
      map['second'] as dynamic,
      third: map['third'] as dynamic,
      four: map['four'] as dynamic,
      selected: map['selected'] as bool,
    );
  }
}

class FieldPairs {
  List<Pairs> content;

  FieldPairs(this.content);
}
