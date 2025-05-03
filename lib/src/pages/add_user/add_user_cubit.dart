import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_server_repository.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_state.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserCubit extends Cubit<AddUserState> {
  String email = '';
  final StoreServerRepository storeRepository;
  final BaseCubit baseCubit;

  List<RoleType>? roleSelected;
  AddUserCubit({
    required this.storeRepository,
    required this.baseCubit,
  }) : super(AddUserInitial());

  doSetEmail(String? value) {
    email = value?.trim() ?? '';
    emit(AddUserRefresh(email));
  }

  Future<void> submit() async {
    emit(AddUserLoading());
    final ApiResult result = await storeRepository.sendInviteToStore(
      storeId: baseCubit.store!.id,
      email: email,
      storeName: baseCubit.store?.name,
      role: roleSelected?.first ?? RoleType.undefined,
    );

    result.when(
      success: (response) {
        emit(AddUserSuccess());
      },
      failure: (error, {errorType}) {
        emit(AddUserFailure(errorType));
      },
    );
  }

  setRoleSelect(List<RoleType> p1) {
    roleSelected = p1;
  }
}
