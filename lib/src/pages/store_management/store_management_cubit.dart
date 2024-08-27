import 'package:ez_shop_sync/src/pages/store_management/store_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreManagementCubit extends Cubit<StoreManagementState> {
  StoreManagementCubit() : super(StoreManagementInitial()) {}
}
