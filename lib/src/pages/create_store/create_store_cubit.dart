import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateStoreCubit extends Cubit<CreateStoreState> {
  final StoreRepository storeRepository;
  final UserRepository userRepository;
  CreateStoreArgrument? argruments;
  final BaseCubit baseCubit;
  String name = '';
  String desc = '';
  CreateStoreCubit({
    required this.storeRepository,
    required this.baseCubit,
    required this.userRepository,
  }) : super(CreateStoreInitial());

  void submit() async {
    emit(CreateStoreLoading());
    final result = await storeRepository.create(
      Store(
        ownerId: baseCubit.userId ?? '',
        name: name,
        description: desc,
        members: [
          Member(uid: baseCubit.user!.uid, role: RoleType.owner.name, email: baseCubit.user!.email!),
        ],
      ),
      appMode: AppMode.server,
    );

    result.when(
      success: (response) async {
        await baseCubit.loadAllDependencies();
        emit(CreateStoreSuccess(response));
      },
      failure: (error, {errorType}) {
        emit(const CreateStoreFailure());
      },
    );
  }

  setName(String? value) {
    name = value ?? '';
    emit(CreateStoreRefresh(name));
  }

  setDescription(String? value) {
    desc = value ?? '';
  }

  void initial(CreateStoreArgrument argruments) {
    this.argruments = argruments;
    emit(CreateStoreInitial());
  }
}
