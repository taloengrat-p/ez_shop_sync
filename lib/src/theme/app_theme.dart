import 'package:hive/hive.dart';

part 'app_theme.g.dart';

@HiveType(typeId: 6)
class AppTheme {
  @HiveField(1)
  String primaryColor;
  @HiveField(2)
  String secondaryColor;
  @HiveField(3)
  String accentColor;
  @HiveField(4)
  String backgroundColor;
  AppTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
  });

  @override
  String toString() =>
      'AppTheme(primaryColor: $primaryColor, secondaryColor: $secondaryColor, accentColor: $accentColor)';
}
