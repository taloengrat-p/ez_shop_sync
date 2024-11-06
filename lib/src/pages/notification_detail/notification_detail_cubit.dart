import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_state.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  NotificationDetailArgrument? argrument;
  final StoreRepository storeRepository;

  NotificationDetailCubit({
    required this.storeRepository,
  }) : super(NotificationDetailInitial()) {}

  void intialize(NotificationDetailArgrument argrument) {
    this.argrument = argrument;
    emit(NotificationDetailInitial());
  }

  void doAccept() async {
    emit(NotificationDetailLoading());
    final result = await storeRepository.acceptInvitation();

    result.when(
      success: (response) {
        emit(NotificationDetailSuccess());
      },
      failure: (error, {errorType}) {
        emit(NotificationDetailFailure(errorType));
      },
    );
  }

  void doReject() async {
    emit(NotificationDetailLoading());
    final result = await storeRepository.rejectInvitation();

    result.when(
      success: (response) {
        emit(NotificationDetailSuccess());
      },
      failure: (error, {errorType}) {
        emit(NotificationDetailFailure(errorType));
      },
    );
  }
}
