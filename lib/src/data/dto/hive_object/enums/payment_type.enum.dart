enum PaymentType {
  cash,
  qrcode,
  undefined;

  factory PaymentType.fromString(String? value) {
    switch (value) {
      case 'cash':
        return cash;
      case 'qrcode':
        return qrcode;
      default:
        return undefined;
    }
  }
}
