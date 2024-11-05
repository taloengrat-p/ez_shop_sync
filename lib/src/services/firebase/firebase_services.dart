import 'dart:developer';

import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class FirebaseServices {
  BaseCubit? baseCubit;
  NavigationService navigationService;
  FirebaseServices({required this.navigationService});
  start(BaseCubit baseCubit) {
    this.baseCubit = baseCubit;
    // startAuthListen();
    // startProfileUpdateListen();
  }

  startAuthListen() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      log('userChanges() $user', name: runtimeType.toString());
      baseCubit?.setCurrentUser(user);
    });
  }

  startProfileUpdateListen() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      log('userChanges() $user', name: runtimeType.toString());
      baseCubit?.setCurrentUser(user);
    });
  }
}
