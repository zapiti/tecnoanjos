import '../../utils/object/object_utils.dart';

import '../code_response.dart';

class ResponsePaginated<T> {
  T content;
  bool last;
  int totalpages;
  int totalElements;
  int size;
  int number;
  String sort;
  bool first;
  int numberOfElements;
  dynamic error;
  dynamic others;

  ResponsePaginated(
      {this.content,
      this.error,
      this.last,
      this.totalpages,
      this.totalElements,
      this.size,
      this.number,
      this.sort,
      this.first,
      this.numberOfElements,
      this.others});

  factory ResponsePaginated.fromMapSimple(T content, {dynamic others}) {
    return ResponsePaginated(content: content ?? [], others: others);
  }

  static ResponsePaginated fromSimpleResponse(CodeResponse response) {
    return ResponsePaginated(
        error: response.error == null
            ? null
            : response.error is Map ? response.error["titulo"] : response.error,
        content: response.sucess);
  }

  factory ResponsePaginated.fromMap(
      dynamic map, T  callT) {
    if (null == map) return null;
    var temp;
    return map is List ?  ResponsePaginated(content: callT): ResponsePaginated(
      content: callT,
      last: null == (temp = map['last'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      totalpages: null == (temp = map['totalpages'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      totalElements: null == (temp = map['totalElements'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      size: null == (temp = map['size'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      number: null == (temp = map['number'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      sort: map['sort']?.toString(),
      first: null == (temp = map['first'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      numberOfElements: null == (temp = map['numberOfElements'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      error: (map['error']),
      others: (map['others']),
    );
  }
}
