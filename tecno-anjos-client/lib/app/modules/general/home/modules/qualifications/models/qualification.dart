// class Qualification {
//   int id;
//   int userId;
//   String name;
//   double money;
//   String status;
//   double orignalValue;
//   double currentValue;
//   String origin;
//   int attendanceId;
//   int qualificationId;
//   int quantity;
//   bool ishours;
//   double sellValue;
//
//   Qualification(
//       {this.id,
//       this.userId,
//       this.name,
//       this.money,
//       this.status,
//       this.orignalValue,
//       this.currentValue,
//       this.origin,
//       this.attendanceId,
//       this.quantity,
//       this.sellValue,
//       this.qualificationId,
//       this.ishours});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userId': userId,
//       'name': name,
//       'money': money,
//       'status': status,
//       'orignalValue': orignalValue,
//       'currentValue': currentValue,
//       'sellValue': sellValue,
//       'origin': origin,
//       'attendanceId': attendanceId,
//       'qualificationId': qualificationId,
//       'quantity': quantity,
//       'ishours': ishours
//     };
//   }
//
//   Map<String, dynamic> toMapEdit() {
//     return {
//       'id': id,
//       'userId': userId,
//       'name': name,
//       'money': money,
//       'ishours': ishours,
//       'status': status,
//       'orignalValue': orignalValue,
//       'currentValue': currentValue,
//       'origin': origin,
//       'quantity': quantity,
//       'sellValue': sellValue
//     };
//   }
//
//   factory Qualification.fromMap(dynamic map) {
//     if (null == map) return null;
//     var temp;
//     return Qualification(
//       id: null == (temp = map['id'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       userId: null == (temp = map['userId'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       name: map['name']?.toString(),
//       money: null == (temp = map['money'] ?? map['currentValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       status: map['status']?.toString(),
//       sellValue: null == (temp = map['sellValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       orignalValue: null == (temp = map['orignalValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       currentValue: null == (temp = map['currentValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       origin: map['origin']?.toString(),
//       attendanceId: null == (temp = map['attendanceId'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       quantity: null == (temp = map['quantity'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       ishours: map['ishours'] ?? false,
//       qualificationId: null == (temp = map['qualificationId'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//     );
//   }
//
//   factory Qualification.fromServerQualification(dynamic map) {
//     if (null == map) return null;
//     var temp;
//     return Qualification(
//       qualificationId: null == (temp = map['id'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       userId: null == (temp = map['userId'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       name: map['name']?.toString(),
//       money: null == (temp = map['money'] ?? map['currentValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       status: map['status']?.toString(),
//       orignalValue: null == (temp = map['orignalValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       currentValue: null == (temp = map['currentValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       sellValue: null == (temp = map['sellValue'])
//           ? null
//           : (temp is num ? temp.toDouble() : double.tryParse(temp)),
//       origin: map['origin']?.toString(),
//       attendanceId: null == (temp = map['attendanceId'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       quantity: null == (temp = map['quantity'])
//           ? null
//           : (temp is num ? temp.toInt() : int.tryParse(temp)),
//       // qualificationId: null == (temp = map['qualificationId'])
//       //     ? null
//       //     : (temp is num ? temp.toInt() : int.tryParse(temp)),
//     );
//   }
//
//   toSimpleNewItem() {
//     if (this.id != null || this.attendanceId != null) {
//       return {
//         'id': id ?? attendanceId,
//         'userId': userId,
//         'name': name,
//         'money': money,
//         'status': status,
//         'orignalValue': orignalValue,
//         'currentValue': currentValue,
//         'ishours': ishours,
//         'origin': origin,
//         'quantity': quantity,
//         'sellValue': sellValue
//       };
//     } else {
//       return {
//         "name": this.name,
//         "status": this.status ?? "A",
//         "currentValue": this.currentValue ?? this.money,
//         'quantity': this.quantity,
//         'ishours': ishours,
//         'origin': origin,
//         'money': money,
//       };
//     }
//   }
//
//   toSimpleNewItemId() {
//     return {'id': this.qualificationId ?? this.id, 'quantity': this.quantity};
//   }
// }
