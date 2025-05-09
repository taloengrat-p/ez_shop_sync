import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CreateStoreCubit extends Cubit<CreateStoreState> {
  final StoreRepository storeRepository;
  final UserRepository userRepository;
  final AppCubit appCubit;

  CreateStoreArgrument? argruments;
  String name = '';
  String desc = '';
  CreateStoreCubit({required this.storeRepository, required this.appCubit, required this.userRepository})
    : super(CreateStoreInitial());

  void submit() async {
    emit(CreateStoreLoading());
    final result = await storeRepository.create(
      BaseRepoRequest(
        storeId: appCubit.storeId ?? '',
        userId: appCubit.userId ?? '',
        data: Store(
          ownerId: appCubit.userId ?? '',
          name: name,
          description: desc,
          members: [Member(uid: appCubit.user!.uid, role: RoleType.owner.name, email: appCubit.user!.email!)],
          products: [],
        ),
      ),
    );

    result.when(
      success: (response) async {
        await appCubit.loadAllDependencies();
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
