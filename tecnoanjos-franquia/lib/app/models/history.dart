

class MyHistory {
  String observacoes;
  String desconto;
  String numero;
  String numeroPedidoLoja;
  String vendedor;
  String valorFrete;
  String totalProdutos;
  double totalvenda;
  String situacao;
  String loja;
  String dataPrevista;
  String tipoIntegracao;
  List<MyItems> itens;

  MyHistory({
      this.observacoes,
      this.desconto,
      this.numero,
      this.numeroPedidoLoja,
      this.vendedor,
      this.valorFrete,
      this.totalProdutos,
      this.totalvenda,
      this.situacao,
      this.loja,
      this.dataPrevista,
      this.tipoIntegracao,
      this.itens});
  Map<String, dynamic> toMapSimple() {
    return {
      'observacoes': observacoes,
      'desconto': desconto,
      'numero': numero,
      'numeroPedidoLoja': numeroPedidoLoja,
      'vendedor': vendedor,
      'valorFrete': valorFrete,
      'totalProdutos': totalProdutos,
      'totalvenda': totalvenda,
      'situacao': situacao,
      'loja': loja,
      'dataPrevista': dataPrevista,
      'tipoIntegracao': tipoIntegracao,
      'itens': itens?.map((map) => map?.toMap())?.toList() ?? [],
    };
  }
  Map<String, dynamic> toMap() {
    return { 'pedido' :{
      'observacoes': observacoes,
      'desconto': desconto,
      'numero': numero,
      'numeroPedidoLoja': numeroPedidoLoja,
      'vendedor': vendedor,
      'valorFrete': valorFrete,
      'totalProdutos': totalProdutos,
      'totalvenda': totalvenda,
      'situacao': situacao,
      'loja': loja,
      'dataPrevista': dataPrevista,
      'tipoIntegracao': tipoIntegracao,
      'itens': itens?.map((map) => map?.toMap())?.toList() ?? [],
    }};
  }
  factory MyHistory.fromMapComum(dynamic tes) {
    if (null == tes) return null;
    if (null == tes) return null;
    var map = tes;
    var temp;
    return MyHistory(
      observacoes: map['observacoes']?.toString(),
      desconto: map['desconto']?.toString(),
      numero: map['numero']?.toString(),
      numeroPedidoLoja: map['numeroPedidoLoja']?.toString(),
      vendedor: map['vendedor']?.toString(),
      valorFrete: map['valorFrete']?.toString(),
      totalProdutos: map['totalProdutos']?.toString(),
      totalvenda: null == (temp = map['totalvenda'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)) ?? 0.0,
      situacao: map['situacao']?.toString(),
      loja: map['loja']?.toString(),
      dataPrevista: map['dataPrevista']?.toString(),
      tipoIntegracao: map['tipoIntegracao']?.toString(),
      itens: null == (temp = map['itens'])
          ? []
          : (temp is List
          ? temp.map((map) => MyItems.fromMap(map)).toList()
          : []),
    );
  }

  factory MyHistory.fromMap(dynamic tes) {
    if (null == tes) return null;
    if (null == tes['pedido']) return null;
    var map = tes['pedido'];
    var temp;
    return MyHistory(
      observacoes: map['observacoes']?.toString(),
      desconto: map['desconto']?.toString(),
      numero: map['numero']?.toString(),
      numeroPedidoLoja: map['numeroPedidoLoja']?.toString(),
      vendedor: map['vendedor']?.toString(),
      valorFrete: map['valorFrete']?.toString(),
      totalProdutos: map['totalProdutos']?.toString(),
      totalvenda: null == (temp = map['totalvenda'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)) ?? 0.0,
      situacao: map['situacao']?.toString(),
      loja: map['loja']?.toString(),
      dataPrevista: map['dataPrevista']?.toString(),
      tipoIntegracao: map['tipoIntegracao']?.toString(),
      itens: null == (temp = map['itens'])
          ? []
          : (temp is List
              ? temp.map((map) => MyItems.fromMap(map)).toList()
              : []),
    );
  }
}

class MyItems {
  String id;
  String codigo;
  String descricao;
  double quantidade;
  double valorunidade;
  String descontoItem;
  String un;
  String pesoBruto;
  String largura;
  String altura;
  String profundidade;
  String unidadeMedida;
  String descricaoDetalhada;

  Map<String, dynamic> toMap() {
    return { 'item': {
      'id': id,
      'codigo': codigo,
      'descricao': descricao,
      'quantidade': quantidade,
      'valorunidade': valorunidade,
      'descontoItem': descontoItem,
      'un': un,
      'pesoBruto': pesoBruto,
      'largura': largura,
      'altura': altura,
      'profundidade': profundidade,
      'unidadeMedida': unidadeMedida,
      'descricaoDetalhada': descricaoDetalhada,
    }};
  }

  MyItems({
      this.id,
      this.codigo,
      this.descricao,
      this.quantidade,
      this.valorunidade,
      this.descontoItem,
      this.un,
      this.pesoBruto,
      this.largura,
      this.altura,
      this.profundidade,
      this.unidadeMedida,
      this.descricaoDetalhada});

  factory MyItems.fromMap(Map item) {
    if (null == item) return null;
    var map = item.containsKey('item')  ? item['item'] : item;
    var temp;
    return MyItems(
      id: map['id']?.toString(),
      codigo: map['codigo']?.toString(),
      descricao: map['descricao']?.toString(),
      quantidade: null == (temp = map['quantidade'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
      valorunidade: null == (temp = map['valorunidade'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
      descontoItem: map['descontoItem']?.toString(),
      un: map['un']?.toString(),
      pesoBruto: map['pesoBruto']?.toString(),
      largura: map['largura']?.toString(),
      altura: map['altura']?.toString(),
      profundidade: map['profundidade']?.toString(),
      unidadeMedida: map['unidadeMedida']?.toString(),
      descricaoDetalhada: map['descricaoDetalhada']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Codigo: $codigo,\nDescrição: $descricao,\nQuantidade: $quantidade,\nValor unitário: $valorunidade, \nun: ${un ??""}, ';
  }
}