import 'package:ez_shop_sync/src/pages/pin_setting/pin_setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinSettingCubit extends Cubit<PinSettingState> {
  PinSettingCubit() : super(PinSettingInitial()) {}
}
