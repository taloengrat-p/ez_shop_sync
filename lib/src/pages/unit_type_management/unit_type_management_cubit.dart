import 'package:ez_shop_sync/src/pages/unit_type_management/unit_type_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UnitTypeManagementCubit extends Cubit<UnitTypeManagementState> {
  UnitTypeManagementCubit() : super(UnitTypeManagementInitial());
}
