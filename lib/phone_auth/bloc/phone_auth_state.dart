part of 'phone_auth_bloc.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthError extends PhoneAuthState {}

class PhoneAuthNumberVerficationFailure extends PhoneAuthState {
  final String message;
  PhoneAuthNumberVerficationFailure(this.message);
  @override
  List<Object> get props => [props];
}

class PhoneAuthNumberVerificationSuccess extends PhoneAuthState {
  final String verificationId;
  PhoneAuthNumberVerificationSuccess({
    required this.verificationId,
  });
  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeSentSuccess extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeSentSuccess({
    required this.verificationId,
  });
  @override
  List<Object> get props => [verificationId];
}

class PhoneAuthCodeVerficationFailure extends PhoneAuthState {
  final String message;
  final String verificationId;

  PhoneAuthCodeVerficationFailure(this.message, this.verificationId);

  @override
  List<Object> get props => [message];
}

class PhoneAuthCodeVerificationSuccess extends PhoneAuthState {
  final String? uid;

  PhoneAuthCodeVerificationSuccess({
    required this.uid,
  });

  @override
  List<Object?> get props => [uid];
}

class PhoneAuthCodeAutoRetrevalTimeoutComplete extends PhoneAuthState {
  final String verificationId;

  PhoneAuthCodeAutoRetrevalTimeoutComplete(this.verificationId);
  @override
  List<Object> get props => [verificationId];
}
