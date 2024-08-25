import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extendsions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreCubit extends Cubit<MoreState> {
  BaseCubit baseCubit;

  List<Store> get stores => [
        Store(id: '1', ownerId: '1', name: 'Store 1'),
        Store(id: '2', ownerId: '2', name: 'Store 2'),
        Store(id: '3', ownerId: '3', name: 'Store 3'),
      ];

  MoreCubit({
    required this.baseCubit,
  }) : super(MoreInitial());

  String get shortName => baseCubit.user?.username.toSubStringFirstToIndex(2) ?? '';

  String get currentStore => baseCubit.store?.name ?? '';
}
