


class Payment {
  String pagarmeStatus;
  String status;
  String createdAt;
  int clientId;
  int technicianId;
  String paymentMethodId;
  int attendanceId;
  double paidAmount;
  double amount;

  Payment({
    this.pagarmeStatus,
    this.status,
    this.createdAt,
    this.clientId,
    this.technicianId,
    this.paymentMethodId,
    this.attendanceId,
    this.paidAmount,
    this.amount});

  factory Payment.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Payment(
      pagarmeStatus: map['pagarmeStatus']?.toString(),
      status: map['status']?.toString(),
      createdAt: map['createdAt']?.toString(),
      clientId: null == (temp = map['clientId'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      technicianId: null == (temp = map['technicianId'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      paymentMethodId: map['paymentMethodId']?.toString(),
      attendanceId: null == (temp = map['attendanceId'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      paidAmount: null == (temp = map['paidAmount'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
      amount: null == (temp = map['splittedValue'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pagarmeStatus': pagarmeStatus,
      'status': status,
      'createdAt': createdAt,
      'clientId': clientId,
      'technicianId': technicianId,
      'paymentMethodId': paymentMethodId,
      'attendanceId': attendanceId,
      'paidAmount': paidAmount,
      'amount': amount,
    };
  }
}
