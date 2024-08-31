import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<MainState> {
  int currentPage = 1;

  MainCubit() : super(MainInitial());

  void setCurrentPageView(int value) {
    currentPage = value;
  }
}
