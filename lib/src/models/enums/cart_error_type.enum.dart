enum CartErrorType {
  insufficient,
  invalid,
  undefined;

  static CartErrorType fromString(String? value) {
    switch (value) {
      case 'insufficient':
        return CartErrorType.insufficient;
      case 'invalid':
        return CartErrorType.invalid;
      default:
        return CartErrorType.undefined;
    }
  }
}
