



class TotalAvaluation {
  int totalSended;
  int totalReceived;
  double   average;

  TotalAvaluation({this.totalSended, this.totalReceived, this.average});

  factory TotalAvaluation.fromMap(Map<String, dynamic> map) {
    return new TotalAvaluation(
      totalSended: int.tryParse(map['totalSended'].toString()) ?? 0,
      totalReceived: int.tryParse(map['totalReceived'].toString()) ?? 0,
      average: double.tryParse(map['average'].toString()) ?? 0.0 ,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'totalSended': this.totalSended,
      'totalReceived': this.totalReceived,
      'average': this.average,
    } as Map<String, dynamic>;
  }
}