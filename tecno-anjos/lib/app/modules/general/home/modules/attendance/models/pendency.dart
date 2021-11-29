
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';

class Pendency {

  int id;
  int markerPendency;
  int receiverPendency;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Pendency({this.id, this.markerPendency, this.receiverPendency,
    this.description, this.createdAt, this.updatedAt});

  factory Pendency.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Pendency(
      id: null == (temp = map['id']) ? null : (temp is num
          ? temp.toInt()
          : int.tryParse(temp)),
      markerPendency: null == (temp = map['markerPendency'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      receiverPendency: null == (temp = map['receiverPendency'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      description: map['description']?.toString(),
      createdAt: null == (temp = map['createdAt']) ? null : (temp is DateTime
          ? temp
          :MyDateUtils.convertDateToDate(temp,null)),
      updatedAt: null == (temp = map['updatedAt']) ? null : (temp is DateTime
          ? temp
          :MyDateUtils.convertDateToDate(temp,null)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'markerPendency': markerPendency,
      'receiverPendency': receiverPendency,
      'description': description,
    };
  }
}

