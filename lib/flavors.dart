enum Flavor {
  dev,
  prod,
  stg;

  static const String DEV = 'dev';
  static const String PROD = 'prod';
  static const String STG = 'tests';
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Ez Shop Sync-DEV';
      case Flavor.stg:
        return 'Ez Shop Sync-STG';
      case Flavor.prod:
        return 'Ez Shop Sync';
    }
  }
}
