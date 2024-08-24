import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreCubit extends Cubit<MoreState> {
  BaseCubit baseCubit;

  MoreCubit({
    required this.baseCubit,
  }) : super(MoreInitial());

  String get shortName =>
      baseCubit.user?.username.substring(0, 2).toUpperCase() ?? '';
}
