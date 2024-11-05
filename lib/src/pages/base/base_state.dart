import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart' as local;

import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as server;

abstract class BaseState extends Equatable {
  final server.User? serverUser;
  final local.User? localServer;
  const BaseState({
    this.localServer,
    this.serverUser,
  }) : super();

  @override
  List<Object?> get props => [serverUser, localServer];
}

class BaseUserChange extends BaseState {
  const BaseUserChange({
    super.serverUser,
    super.localServer,
  });

  @override
  List<Object?> get props => [serverUser, localServer];
}

class BaseInitial extends BaseState {
  @override
  String toString() => 'BaseInitial';
}

class BaseInitialSuccess extends BaseState {
  @override
  String toString() => 'BaseInitialSuccess';
}

class BaseLoading extends BaseState {
  @override
  String toString() => 'BaseLoading';
}

class BaseSuccess extends BaseState {
  @override
  String toString() => 'BaseSuccess';
}

class BaseFailure extends BaseState {
  @override
  String toString() => 'BaseFailure';
}

class BaseLoadAppThemeSuccess extends BaseState {
  final AppTheme? appTheme;

  const BaseLoadAppThemeSuccess(
    this.appTheme,
  );
  @override
  String toString() => 'BaseLoadAppThemeSuccess $appTheme';

  @override
  List<Object?> get props => [appTheme?.primaryColor, appTheme?.secondaryColor, appTheme?.accentColor];
}

class BaseRefresh extends BaseState {
  final DateTime dateTime;

  const BaseRefresh(this.dateTime);
  @override
  String toString() => 'BaseRefresh';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}

class BaseChangeAppMode extends BaseState {
  final AppMode mode;

  const BaseChangeAppMode(this.mode);

  @override
  String toString() => 'BaseChangeAppMode';

  @override
  List<Object?> get props => [mode];
}

class BaseInitialLocalStorageServiceSuccess extends BaseState {
  @override
  String toString() => 'BaseInitialLocalStorageServiceSuccess';
}

class BaseAddCartSuccess extends BaseState {
  @override
  String toString() => 'BaseAddCartSuccess';
}

class BaseAddCartAnimationSuccess extends BaseState {
  @override
  String toString() => 'BaseAddCartAnimationSuccess';
}

class BaseLoadTagsByStoreSuccess extends BaseState {
  final List<String> tagIds;

  const BaseLoadTagsByStoreSuccess(
    this.tagIds,
  );

  @override
  List<Object?> get props => [...tagIds];

  @override
  String toString() => 'BaseLoadTagsByStoreSuccess(tagIds: $tagIds)';
}

class BaseLoadCategoriesByStoreSuccess extends BaseState {
  final List<String> categories;

  const BaseLoadCategoriesByStoreSuccess(
    this.categories,
  );

  @override
  List<Object?> get props => [...categories];

  @override
  String toString() => 'BaseLoadCategoriesByStoreSuccess(categories: $categories)';
}

class BaseRemoveCartItem extends BaseState {
  @override
  String toString() => 'BaseRemoveCartItem';
}

class BaseAddStockSuccess extends BaseState {
  final DateTime dateTime;

  const BaseAddStockSuccess(this.dateTime);

  @override
  String toString() => 'BaseAddStockSuccess ${dateTime.toIso8601String()}';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}
