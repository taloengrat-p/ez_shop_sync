import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class AddProductHistoryDetailState extends Equatable {
  const AddProductHistoryDetailState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class AddProductHistoryDetailRefresh extends AddProductHistoryDetailState {
  final dynamic value;

  const AddProductHistoryDetailRefresh(this.value);
  @override
  String toString() => 'AddProductHistoryDetailRefresh';

  @override
  List<Object?> get props => [value];
}

class AddProductHistoryDetailScreenModeChange extends AddProductHistoryDetailState {
  final ScreenMode mode;

  const AddProductHistoryDetailScreenModeChange(this.mode);

  @override
  String toString() => 'AddProductHistoryDetailScreenModeChange';
}

class AddProductHistoryDetailInitial extends AddProductHistoryDetailState {
  @override
  String toString() => 'AddProductHistoryDetailInitial';
}

class AddProductHistoryDetailInitialLoading extends AddProductHistoryDetailState {
  @override
  String toString() => 'AddProductHistoryDetailInitialLoading';
}

class AddProductHistoryDetailLoading extends AddProductHistoryDetailState {
  @override
  String toString() => 'AddProductHistoryDetailLoading';
}

class AddProductHistoryDetailSuccess extends AddProductHistoryDetailState {
  @override
  String toString() => 'AddProductHistoryDetailSuccess';
}

class AddProductHistoryDetailFailure extends AddProductHistoryDetailState {
  const AddProductHistoryDetailFailure();

  @override
  String toString() => 'AddProductHistoryDetailFailure';
}

class AddProductHistoryDetailArgruments extends AddProductHistoryDetailState {
  final AddProduct? addProduct;
  final String? addProductId;
  const AddProductHistoryDetailArgruments({this.addProduct, this.addProductId});

  @override
  String toString() => 'AddProductHistoryDetailArgruments $addProductId';

  @override
  List<Object?> get props => [addProduct, addProductId];
}
