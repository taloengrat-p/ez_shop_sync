import 'package:ez_shop_sync/src/pages/user_management/user_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  UserManagementCubit() : super(UserManagementInitial());
}
