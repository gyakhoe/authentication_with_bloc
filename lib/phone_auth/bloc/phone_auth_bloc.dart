import 'dart:async';

import 'package:authentication_with_bloc/phone_auth/data/models/phone_auth_model.dart';
import 'package:authentication_with_bloc/phone_auth/data/repositories/phone_auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthRepository _phoneAuthRepository;
  PhoneAuthBloc({required PhoneAuthRepository phoneAuthRepository})
      : _phoneAuthRepository = phoneAuthRepository,
        super(PhoneAuthInitial());

  @override
  Stream<PhoneAuthState> mapEventToState(
    PhoneAuthEvent event,
  ) async* {
    if (event is PhoneAuthNumberVerified) {
      yield* _phoneAuthNumberVerifiedToState(event);
    } else if (event is PhoneAuthCodeAutoRetrevalTimeout) {
      yield PhoneAuthCodeAutoRetrevalTimeoutComplete(event.verificationId);
    } else if (event is PhoneAuthCodeSent) {
      yield PhoneAuthNumberVerificationSuccess(
          verificationId: event.verificationId);
    } else if (event is PhoneAuthVerificationFailed) {
      yield PhoneAuthNumberVerficationFailure(event.message);
    } else if (event is PhoneAuthVerificationCompleted) {
      yield PhoneAuthCodeVerificationSuccess(uid: event.uid);
    } else if (event is PhoneAuthCodeVerified) {
      yield* _phoneAuthCodeVerifiedToState(event);
    }
  }

  Stream<PhoneAuthState> _phoneAuthNumberVerifiedToState(
      PhoneAuthNumberVerified event) async* {
    try {
      yield PhoneAuthLoading();
      await _phoneAuthRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        onCodeAutoRetrievalTimeOut: _onCodeAutoRetrievalTimeout,
        onCodeSent: _onCodeSent,
        onVerificaitonFailed: _onVerificationFailed,
        onVerificationCompleted: _onVerificationCompleted,
      );
    } on Exception catch (e) {
      print('Exception occured while verifying phone number ${e.toString()}');
      yield PhoneAuthNumberVerficationFailure(e.toString());
    }
  }

  Stream<PhoneAuthState> _phoneAuthCodeVerifiedToState(
      PhoneAuthCodeVerified event) async* {
    try {
      yield PhoneAuthLoading();
      PhoneAuthModel phoneAuthModel = await _phoneAuthRepository.verifySMSCode(
          smsCode: event.smsCode, verificationId: event.verificationId);
      yield PhoneAuthCodeVerificationSuccess(uid: phoneAuthModel.uid);
    } on Exception catch (e) {
      print('Excpetion occured while verifying OTP code ${e.toString()}');
      yield PhoneAuthCodeVerficationFailure(e.toString(), event.verificationId);
    }
  }

  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    final PhoneAuthModel phoneAuthModel =
        await _phoneAuthRepository.verifyWithCredential(credential: credential);
    if (phoneAuthModel.phoneAuthModelState == PhoneAuthModelState.verified) {
      add(PhoneAuthVerificationCompleted(phoneAuthModel.uid));
    }
  }

  void _onVerificationFailed(FirebaseException exception) {
    print(
        'Exception has occured while verifying phone number: ${exception.toString()}');
    add(PhoneAuthVerificationFailed(exception.toString()));
  }

  void _onCodeSent(String verificationId, int? token) {
    print(
        'Print code is successfully sent with verification id $verificationId and token $token');

    add(PhoneAuthCodeSent(
      token: token,
      verificationId: verificationId,
    ));
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
    print('Auto retrieval has timed out for verification ID $verificationId');
    add(PhoneAuthCodeAutoRetrevalTimeout(verificationId));
  }
}
