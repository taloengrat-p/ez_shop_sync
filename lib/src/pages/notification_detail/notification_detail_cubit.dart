import 'package:ez_shop_sync/src/data/repository/store/server/dev_store_server_repository.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  NotificationDetailArgrument? argrument;
  final StoreServerRepository storeServerRepository;

  NotificationDetailCubit({
    required this.storeServerRepository,
  }) : super(NotificationDetailInitial());

  void intialize(NotificationDetailArgrument argrument) {
    this.argrument = argrument;
    emit(NotificationDetailInitial());
  }

  void doAccept() async {
    emit(NotificationDetailLoading());
    final result = await storeServerRepository.acceptInvitation(
      argrument?.notification.id,
      argrument?.notification.payload?['storeId'],
      argrument?.notification.payload,
    );

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
    final result = await storeServerRepository.rejectInvitation();

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
