import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  BaseCubit baseCubit;
  HomeCubit({
    required this.baseCubit,
  }) : super(HomeInitial());
}
