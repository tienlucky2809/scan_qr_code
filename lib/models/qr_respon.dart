class QRRespon {
  String? binCode;
  String? bankName;
  String? accCode;
  String? amount;
  String? contentTransfer;
  String? serviceCode;


  QRRespon(
      {this.binCode,
      this.accCode,
      this.amount,
      this.contentTransfer,
      this.serviceCode,
      this.bankName});

  factory QRRespon.fromJson(Map<String, dynamic> json) {
    return QRRespon(
        binCode: json['binCode'],
        accCode: json['accCode'],
        amount: json['amount'],
        contentTransfer: json['contentTransfer'],
        serviceCode: json['serviceCode'],
        bankName: json['bankName']);
  }

  @override
  String toString() {
    return '$binCode $bankName $accCode $serviceCode $amount $contentTransfer';
  }
}

