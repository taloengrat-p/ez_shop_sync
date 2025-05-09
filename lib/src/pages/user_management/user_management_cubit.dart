import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UserManagementCubit extends Cubit<UserManagementState> {
  final StoreRepository storeRepository;
  final AppCubit appCubit;
  List<Member> members = [];
  UserManagementCubit({required this.storeRepository, required this.appCubit}) : super(UserManagementInitial());

  initial() async {
    emit(UserManagementLoading());
    members = appCubit.store?.members ?? [];
  }
}
