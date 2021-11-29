import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';

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
  int status;
  dynamic error;
  dynamic others;
  double average;

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
      this.numberOfElements,this.average,
      this.others, this. status});

  factory ResponsePaginated.fromMap(dynamic result, T content, {int status}) {
    final map = ObjectUtils.parseToMap(result, defaultValue: {});

    return ResponsePaginated(
      content: content ?? [],
      last: map['last'] as bool,
      average: double.parse(map['average']?.toString() ?? 0.toString()),
      status: status,
      totalpages:
          (int.parse(map['totalPages']?.toString() ?? 0.toString())) + 1,
      totalElements:
          int.parse(map['totalElements']?.toString() ?? 0.toString()),
      size: int.parse(map['size']?.toString() ?? 0.toString()),
      number: int.parse(map['number']?.toString() ?? 0.toString()),
      sort: map['sort'] as String,
      first: map['first'] as bool,
      numberOfElements:
          int.parse(map['numberOfElements']?.toString() ?? 0.toString()),
    );
  }

  factory ResponsePaginated.fromMapSimple(T content, {dynamic others, int status}) {
    return ResponsePaginated(content: content ?? [], others: others,status: status);
  }

  static ResponsePaginated fromSimpleResponse(CodeResponse response) {
    return ResponsePaginated(
        error: response.error == null
            ? null
            : response.error is Map ? response.error["titulo"] : response.error,
        content: response.sucess);
  }
}
