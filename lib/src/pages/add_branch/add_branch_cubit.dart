// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/request/store_request/add_branch_request.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_branch/add_branch_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddBranchCubit extends Cubit<AddBranchState> {
  final StoreRepository storeRepository;
  final AppCubit appCubit;

  String name = '';

  List<RoleType>? roleSelected;
  AddBranchCubit({required this.storeRepository, required this.appCubit}) : super(AddBranchInitial());

  doSetName(String? value) {
    name = value?.trim() ?? '';
    emit(AddBranchRefresh(name));
  }

  Future<void> submit() async {
    emit(AddBranchLoading());
    final ApiResult result = await storeRepository.createBranch(appCubit.request(AddBranchRequest(name: name)));

    result.when(
      success: (response) {
        emit(AddBranchSuccess(branch: response));
      },
      failure: (error, {errorType}) {
        emit(AddBranchFailure(error));
      },
    );
  }

  setRoleSelect(List<RoleType> p1) {
    roleSelected = p1;
  }
}
