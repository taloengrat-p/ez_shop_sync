import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
@Singleton()
class NotificationCubit extends Cubit<NotificationState> {
  final AppCubit appCubit;
  List<Notification> notifications = [];
  NotificationArgrument? argrument;

  NotificationCubit({required this.appCubit}) : super(NotificationInitial());

  Future<void> initial({NotificationArgrument? argrument, bool force = false}) async {
    emit(NotificationLoading());
    if (force) {
      await appCubit.loadNotifications();
      setNotification(appCubit.notification);
    } else {
      setNotification(argrument?.notifications ?? this.argrument?.notifications ?? []);
    }
    emit(NotificationSuccess());
  }

  void setNotification(List<Notification>? items) {
    notifications = items ?? argrument?.notifications ?? [];
  }
}
