import 'package:ez_shop_sync/src/pages/verify_phone_number/verify_phone_number_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class VerifyPhoneNumberCubit extends Cubit<VerifyPhoneNumberState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  VerifyPhoneNumberArgrument? argrument;
  String? _verificationId;
  int? _resendToken;
  String? get verificationId => _verificationId;

  VerifyPhoneNumberCubit() : super(VerifyPhoneNumberInitial());

  initial(VerifyPhoneNumberArgrument argrument) async {
    this.argrument = argrument;

    if (this.argrument == null) {
      return;
    }

    verifyPhoneNumber();
  }

  verifyPhoneNumber({int? resentToken}) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: argrument?.phoneNumber,
      forceResendingToken: resentToken,
      timeout: const Duration(minutes: 1),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification case
        await _firebaseAuth.currentUser!.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(VerifyPhoneNumberFailure(e.message ?? ''));
      },
      codeSent: (String verificationId, int? resendToken) {
        // Save the verificationId so you can use it later
        _verificationId = verificationId;
        _resendToken = resendToken;
        emit(VerifyPhoneNumberRefresh(DateTime.now()));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        emit(VerifyPhoneNumberRefresh(DateTime.now()));
      },
    );
  }

  void doVerify(String value) async {}

  void refresh() {
    emit(VerifyPhoneNumberRefresh(DateTime.now()));
  }
}
