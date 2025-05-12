import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/branch_detail_management/branch_detail_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class BranchDetailManagementCubit extends Cubit<BranchDetailManagementState> {
  final AppCubit appCubit;
  Branch? branch;
  Store? store;
  List<Member> _members = [];
  List<Member> get members => _members;
  BranchDetailManagementCubit({required this.appCubit}) : super(BranchDetailManagementInitial());

  void initial(BranchDetailManagementArgrument argrument) {
    emit(BranchDetailManagementInitial());
    branch = argrument.branch;
    _members =
        appCubit.store?.members.map((Member e) {
          if (store?.memberIds.contains(e.uid) ?? false) {
            e.isSelect = true;
            return e;
          } else {
            e.isSelect = false;
            return e;
          }
        }).toList() ??
        [];
    emit(BranchDetailManagementSuccess());
  }

  void onCheckedChanged(bool? value) {}
}
