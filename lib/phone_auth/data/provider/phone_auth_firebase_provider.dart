import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PhoneAuthFirebaseProvider {
  final FirebaseAuth _firebaseAuth;

  PhoneAuthFirebaseProvider({
    FirebaseAuth firebaseAuth,
  })  : assert(firebaseAuth != null),
        _firebaseAuth = firebaseAuth;

  Future<void> verifyPhoneNumber({
    @required String mobileNumber,
    @required onVerificationCompleted,
    @required onVerificaitonFailed,
    @required onCodeSent,
    @required onCodeAutoRetrievalTimeOut,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificaitonFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeOut,
      timeout: Duration(seconds: 5),
    );
  }

  Future<User> loginWithSMSVerificationCode(
      {@required String verificationId,
      @required String smsVerficationcode}) async {
    final AuthCredential credential = _getAuthCredentialFromVerificationCode(
        verificationId: verificationId, verificationCode: smsVerficationcode);
    return await authenticationWithCredential(credential: credential);
  }

  Future<User> authenticationWithCredential(
      {@required AuthCredential credential}) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  AuthCredential _getAuthCredentialFromVerificationCode(
      {@required String verificationId, @required String verificationCode}) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: verificationCode,
    );
  }
}
