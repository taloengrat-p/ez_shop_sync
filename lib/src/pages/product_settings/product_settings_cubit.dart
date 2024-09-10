import 'package:ez_shop_sync/src/pages/product_settings/product_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSettingsCubit extends Cubit<ProductSettingsState> {
  ProductSettingsCubit() : super(ProductSettingsInitial()) {}
}
