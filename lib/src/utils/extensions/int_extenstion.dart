extension IntExtenstion on int {
  int toMinute() {
    var minutes = this / 60;
    return minutes.toInt();
  }
}
