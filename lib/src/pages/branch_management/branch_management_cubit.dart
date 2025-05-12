import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/branch_management/branch_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class BranchManagementCubit extends Cubit<BranchManagementState> {
  final StoreRepository storeRepository;
  final AppCubit appCubit;

  List<Branch> _branches = [];
  List<Branch> get branches => _branches;
  BranchManagementCubit({required this.storeRepository, required this.appCubit}) : super(BranchManagementInitial());

  initial() async {
    emit(BranchManagementInitialLoading());
    _branches = appCubit.branches.toList();
    emit(BranchManagementSuccess());
  }

  void refresh() async {
    emit(BranchManagementLoading());
    final result = await appCubit.doGetBranchByCurrentStore();

    result.when(
      success: (response) {
        _branches = response;
        emit(BranchManagementSuccess());
      },
      failure: (error) {
        emit(BranchManagementRefreshFailure());
      },
    );
  }

  void deleteBranch(Branch branch) async {
    final result = await appCubit.deleteBranch(appCubit.request(branch.id));

    result.when(
      success: (response) {
        _branches.removeWhere((e) => e.id == branch.id);
        emit(BranchManagementDeleteSuccess(branch: branch));
      },
      failure: (error) {
        emit(BranchManagementDeleteSuccess(branch: branch));
      },
    );
  }
}
