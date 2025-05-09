import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/repository/store/server/dev_store_server_repository.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_state.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddUserCubit extends Cubit<AddUserState> {
  final StoreServerRepository storeRepository;
  final AppCubit appCubit;

  String email = '';

  List<RoleType>? roleSelected;
  AddUserCubit({required this.storeRepository, required this.appCubit}) : super(AddUserInitial());

  doSetEmail(String? value) {
    email = value?.trim() ?? '';
    emit(AddUserRefresh(email));
  }

  Future<void> submit() async {
    emit(AddUserLoading());
    final ApiResult result = await storeRepository.sendInviteToStore(
      storeId: appCubit.store!.id,
      email: email,
      storeName: appCubit.store?.name,
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
