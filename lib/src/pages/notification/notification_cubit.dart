import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  List<Notification> notifications = [];
  NotificationCubit() : super(NotificationInitial());

  void initial(NotificationArgrument argruments) {
    notifications = argruments.notifications;
    emit(NotificationInitial());
  }
}
