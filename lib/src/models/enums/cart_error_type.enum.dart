enum CartErrorType {
  insufficient,
  undefined;

  static CartErrorType fromString(String? value) {
    switch (value) {
      case 'insufficient':
        return CartErrorType.insufficient;
      default:
        return CartErrorType.undefined;
    }
  }
}
