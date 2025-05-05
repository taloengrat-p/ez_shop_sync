import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  AppCubit baseCubit;
  HomeCubit({
    required this.baseCubit,
  }) : super(HomeInitial());
}
