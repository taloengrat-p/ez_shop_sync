import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateStoreCubit extends Cubit<CreateStoreState> {
  CreateStoreCubit() : super(CreateStoreInitial()) {}
}
