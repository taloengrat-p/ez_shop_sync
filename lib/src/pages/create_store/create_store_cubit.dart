import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CreateStoreCubit extends Cubit<CreateStoreState> {
  final StoreRepository storeRepository;
  final UserRepository userRepository;

  final BaseCubit baseCubit;
  String name = '';
  String desc = '';
  CreateStoreCubit({
    required this.storeRepository,
    required this.baseCubit,
    required this.userRepository,
  }) : super(CreateStoreInitial());

  void submit() async {
    final storeCreated = await storeRepository.create(
      Store(
        id: const Uuid().v1(),
        ownerId: baseCubit.user?.id ?? '',
        name: name,
        description: desc,
      ),
    );

    User userUpdated = baseCubit.user!..storeId?.add(storeCreated.id);
    User resultUserUpdated = await userRepository.update(baseCubit.user!.id, userUpdated);

    baseCubit.setCurrentUser(resultUserUpdated);
    baseCubit.setCurrentStoreById(storeCreated.id);
    emit(CreateStoreSuccess(storeCreated));
  }

  setName(String? value) {
    name = value ?? '';
  }

  setDescription(String? value) {
    desc = value ?? '';
  }
}
