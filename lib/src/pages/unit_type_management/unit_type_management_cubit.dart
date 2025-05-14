import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/unit_type_management/unit_type_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UnitTypeManagementCubit extends Cubit<UnitTypeManagementState> {
  final StoreRepository storeRepository;
  final AppCubit appCubit;

  List<UnitType> _unitTypes = [];
  List<UnitType> get unitTypes => _unitTypes;
  UnitTypeManagementCubit({required this.storeRepository, required this.appCubit}) : super(UnitTypeManagementInitial());

  initial() async {
    emit(UnitTypeManagementInitialLoading());
    _unitTypes = appCubit.unitTypes.toList();
    emit(UnitTypeManagementSuccess());
  }

  void refresh() async {
    emit(UnitTypeManagementLoading());
    final result = await appCubit.doGetUniTypeByCurrentStore();

    result.when(
      success: (response) {
        _unitTypes = response;
        emit(UnitTypeManagementSuccess());
      },
      failure: (error) {
        emit(UnitTypeManagementRefreshFailure());
      },
    );
  }

  void deleteBranch(UnitType? unitType) async {
    if (unitType != null) {
      final result = await appCubit.deleteBranch(appCubit.request(unitType.id));

      result.when(
        success: (response) {
          _unitTypes.removeWhere((e) => e.id == unitType.id);
          emit(UnitTypeManagementDeleteSuccess(unitType: unitType));
        },
        failure: (error) {
          emit(UnitTypeManagementDeleteSuccess(unitType: unitType));
        },
      );
    }
  }

  void createUnitType(UnitType unitType) async {
    _unitTypes.add(unitType);
    emit(UnitTypeManagementSuccess());
  }

  void editUnitType(UnitType result) async {
    int index = _unitTypes.indexWhere((unitType) => unitType.id == result.id);
    if (index != -1) {
      _unitTypes[index] = result;
    }
    appCubit.updateUnitType(result);
    emit(UnitTypeManagementSuccess());
  }
}
