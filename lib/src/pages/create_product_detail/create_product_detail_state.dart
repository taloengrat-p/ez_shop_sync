import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class CreateProductDetailState extends Equatable {
  const CreateProductDetailState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class CreateProductDetailRefresh extends CreateProductDetailState {
  final dynamic value;

  const CreateProductDetailRefresh(this.value);
  @override
  String toString() => 'CreateProductDetailRefresh';

  @override
  List<Object?> get props => [value];
}

class CreateProductDetailScreenModeChange extends CreateProductDetailState {
  final ScreenMode mode;

  const CreateProductDetailScreenModeChange(this.mode);

  @override
  String toString() => 'CreateProductDetailScreenModeChange';
}

class CreateProductDetailInitial extends CreateProductDetailState {
  @override
  String toString() => 'CreateProductDetailInitial';
}

class CreateProductDetailUpdateImage extends CreateProductDetailState {
  final dynamic image;

  const CreateProductDetailUpdateImage(
    this.image,
  );
  @override
  String toString() => 'CreateProductDetailUpdateImage $image';

  @override
  List<Object?> get props => [image];
}

class CreateProductDetailLoading extends CreateProductDetailState {
  @override
  String toString() => 'CreateProductDetailLoading';
}

class CreateProductDetailSuccess extends CreateProductDetailState {
  @override
  String toString() => 'CreateProductDetailSuccess';
}

class CreateProductDetailFailure extends CreateProductDetailState {
  const CreateProductDetailFailure();

  @override
  String toString() => 'CreateProductDetailFailure';
}
