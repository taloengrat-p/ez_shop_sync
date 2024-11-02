enum TransactionType {
  income,
  expenses,
  undefined;

  static TransactionType fromString(String? value) {
    switch (value) {
      case 'income':
        return TransactionType.income;
      case 'expenses':
        return TransactionType.expenses;

      default:
        return TransactionType.undefined;
    }
  }
}
