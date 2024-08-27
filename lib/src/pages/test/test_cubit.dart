import 'package:ez_shop_sync/src/pages/test/test_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial()) {}
}
