abstract class BaseObject {
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }
}
