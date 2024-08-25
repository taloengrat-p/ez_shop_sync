extension ObjectExtensions on dynamic {
  bool get isNull => this == null;
  bool get isNotNull => !isNull;
}
