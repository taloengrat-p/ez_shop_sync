// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';

abstract class AppState extends Equatable {
  const AppState() : super();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {
  @override
  String toString() => 'AppInitial';
}

class AppInitialSuccess extends AppState {
  @override
  String toString() => 'AppInitialSuccess';
}

class AppSelectStore extends AppState {
  final String? id;
  const AppSelectStore(this.id);
  @override
  String toString() => 'AppSelectStore $id';

  @override
  List<Object?> get props => [id];
}

class AppGetStoreSuccess extends AppState {
  final List<Store> stores;

  const AppGetStoreSuccess(this.stores);
  @override
  String toString() => 'AppGetStoreSuccess $stores';
  @override
  List<Object?> get props => stores;
}

class AppGetStoreFailure extends AppState {
  @override
  String toString() => 'AppGetStoreFailure';
}

class AppGetUserDataSuccess extends AppState {
  @override
  String toString() => 'AppGetUserDataSuccess';
}

class AppGetNotificationsSuccess extends AppState {
  @override
  String toString() => 'AppGetNotificationsSuccess';
}

class AppGetNotificationsFailure extends AppState {
  @override
  String toString() => 'AppGetNotificationsFailure';
}

class AppGetUserDataFailure extends AppState {
  @override
  String toString() => 'AppGetUserDataFailure';
}

class AppLoading extends AppState {
  @override
  String toString() => 'AppLoading';
}

class AppSuccess extends AppState {
  @override
  String toString() => 'AppSuccess';
}

class AppFailure extends AppState {
  @override
  String toString() => 'AppFailure';
}

class AppUserChange extends AppState {
  final User? user;
  const AppUserChange(this.user);
  @override
  String toString() => 'AppUserChange $user';
  @override
  List<Object?> get props => [user];
}

class AppLoadAppThemeSuccess extends AppState {
  final AppTheme? appTheme;

  const AppLoadAppThemeSuccess(this.appTheme);
  @override
  String toString() => 'AppLoadAppThemeSuccess $appTheme';

  @override
  List<Object?> get props => [appTheme?.primaryColor, appTheme?.secondaryColor, appTheme?.accentColor];
}

class AppRefresh extends AppState {
  final DateTime dateTime;

  const AppRefresh(this.dateTime);
  @override
  String toString() => 'AppRefresh';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}

class AppChangeAppMode extends AppState {
  final AppMode mode;

  const AppChangeAppMode(this.mode);

  @override
  String toString() => 'AppChangeAppMode $mode';

  @override
  List<Object?> get props => [mode];
}

class AppInitialLocalStorageServiceSuccess extends AppState {
  @override
  String toString() => 'AppInitialLocalStorageServiceSuccess';
}

class AppAddCartSuccess extends AppState {
  @override
  String toString() => 'AppAddCartSuccess';
}

class AppDeleteProductSuccess extends AppState {
  @override
  String toString() => 'AppDeleteProductSuccess';
}

class AppDeleteProductFailure extends AppState {
  @override
  String toString() => 'AppDeleteProductFailure';
}

class AppAddCartAnimationSuccess extends AppState {
  @override
  String toString() => 'AppAddCartAnimationSuccess';
}

class AppLoadTagsByStoreSuccess extends AppState {
  final List<String> tagIds;

  const AppLoadTagsByStoreSuccess(this.tagIds);

  @override
  List<Object?> get props => [...tagIds];

  @override
  String toString() => 'AppLoadTagsByStoreSuccess(tagIds: $tagIds)';
}

class AppLoadCategoriesByStoreSuccess extends AppState {
  final List<String> categories;

  const AppLoadCategoriesByStoreSuccess(this.categories);

  @override
  List<Object?> get props => [...categories];

  @override
  String toString() => 'AppLoadCategoriesByStoreSuccess(categories: $categories)';
}

class AppRemoveCartItem extends AppState {
  @override
  String toString() => 'AppRemoveCartItem';
}

class AppAddStockSuccess extends AppState {
  final DateTime dateTime;

  const AppAddStockSuccess(this.dateTime);

  @override
  String toString() => 'AppAddStockSuccess ${dateTime.toIso8601String()}';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}

class AppAddStockFailure extends AppState {
  final ApiError error;
  const AppAddStockFailure(this.error);

  @override
  String toString() => 'AppAddStockFailure $error';

  @override
  List<Object?> get props => [error];
}

class AppCartUpdate extends AppState {
  @override
  String toString() => 'AppCartUpdate';
}

class AppBranchSuccess extends AppState {
  final List<Branch> branches;
  const AppBranchSuccess({required this.branches});

  @override
  String toString() => 'AppCartUpdate $branches';

  @override
  List<Object?> get props => [branches];
}
