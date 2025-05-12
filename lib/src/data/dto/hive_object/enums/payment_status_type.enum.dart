enum PaymentStatusType {
  pending,
  paid,
  failed,
  cancelled,
  expired,
  undefined;

  factory PaymentStatusType.fromString(String? value) {
    switch (value) {
      case 'pending':
        return pending;
      case 'paid':
        return paid;
      case 'failed':
        return failed;
      case 'cancelled':
        return cancelled;
      case 'expired':
        return expired;
      default:
        return undefined;
    }
  }
}
