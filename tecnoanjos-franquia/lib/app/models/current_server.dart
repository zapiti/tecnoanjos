
import 'package:tecnoanjos_franquia/app/core/utils/response_utils.dart';

class CurrentServer {
  String ATIVO;
  String NOMESERV;
  String CODSERV;
  String PORTSERV;
  String IPSERV;

  CurrentServer(
      {this.ATIVO, this.NOMESERV, this.CODSERV, this.PORTSERV, this.IPSERV});

  Map<String, dynamic> toMap() {
    return {
      'ATIVO': ATIVO,
      'NOMESERV': NOMESERV,
      'CODSERV': CODSERV,
      'PORTSERV': PORTSERV,
      'IPSERV': IPSERV,
    };
  }

  static CurrentServer fromMap(dynamic map) {
    if (null == map) return null;
    return CurrentServer(
      ATIVO: ResponseUtils.getValueTypeSK(map['ATIVO'])?.toString(),
      NOMESERV: ResponseUtils.getValueTypeSK(map['NOMESERV'])?.toString(),
      CODSERV: ResponseUtils.getValueTypeSK(map['CODSERV'])?.toString(),
      PORTSERV: ResponseUtils.getValueTypeSK(map['PORTSERV'])?.toString(),
      IPSERV: ResponseUtils.getValueTypeSK(map['IPSERV'])?.toString(),
    );
  }

  String toServerUrl() {
    return this.IPSERV.contains("http")
        ? (this.IPSERV.contains(this.PORTSERV) ? this.IPSERV: "${this.IPSERV}:${this.PORTSERV}")
        : "http://${this.IPSERV}:${this.PORTSERV}";
  }
  String toServerUrlComum() {
    return this.IPSERV.contains("http")
        ? this.IPSERV
        : "http://${this.IPSERV}";
  }
}
