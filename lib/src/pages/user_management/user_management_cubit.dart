import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final StoreRepository storeRepository;
  final BaseCubit baseCubit;
  List<Member> members = [];
  UserManagementCubit({
    required this.storeRepository,
    required this.baseCubit,
  }) : super(UserManagementInitial());

  initial() async {
    emit(UserManagementLoading());
    members = baseCubit.store?.members ?? [];
  }
}
