extension NumExtension on num {
  String prefixCurrency() {
    return '฿ $this';
  }

  String suffuxCurrency() {
    return '฿ $this';
  }
}

extension NumNullableExtension on num? {
  String elsePrefixCurrency() {
    return '฿ ${this ?? '--'}';
  }

  String elseSuffuxCurrency() {
    return '฿ ${this ?? '--'}';
  }
}
