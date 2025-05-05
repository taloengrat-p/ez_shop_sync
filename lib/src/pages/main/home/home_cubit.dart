import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class HomeCubit extends Cubit<HomeState> {
  final AppCubit appCubit;
  HomeCubit({required this.appCubit}) : super(HomeInitial());
}
