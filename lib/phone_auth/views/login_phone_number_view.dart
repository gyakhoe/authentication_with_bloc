import 'package:authentication_with_bloc/home/views/home_main_view.dart';
import 'package:authentication_with_bloc/login/views/login_main_view.dart';
import 'package:authentication_with_bloc/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPhoneNumberView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginMainView()));
            },
          ),
          title: Text('Phone Login'),
        ),
        body: _PhoneAuthViewBuilder(),
      ),
    );
  }
}

class _PhoneAuthViewBuilder extends StatelessWidget {
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _codeNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
      listener: (previous, current) {
        if (current is PhoneAuthCodeVerificationSuccess) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeMainView()));
        } else if (current is PhoneAuthCodeVerficationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthError) {
          _showSnackBarWithText(
              context: context, textValue: 'Uexpected error occurred.');
        } else if (current is PhoneAuthNumberVerficationFailure) {
          _showSnackBarWithText(context: context, textValue: current.message);
        } else if (current is PhoneAuthNumberVerificationSuccess) {
          _showSnackBarWithText(
              context: context,
              textValue: 'SMS code is sent to your mobile number.');
        } else if (current is PhoneAuthCodeAutoRetrevalTimeoutComplete) {
          _showSnackBarWithText(
              context: context, textValue: 'Time out for auto retrieval');
        }
      },
      builder: (context, state) {
        if (state is PhoneAuthInitial) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthNumberVerificationSuccess) {
          return _codeVerificationWidget(context, state.verificationId);
        } else if (state is PhoneAuthNumberVerficationFailure) {
          return _phoneNumberSubmitWidget(context);
        } else if (state is PhoneAuthCodeVerficationFailure) {
          return _codeVerificationWidget(
            context,
            state.verificationId,
          );
        } else if (state is PhoneAuthLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }

  Widget _phoneNumberSubmitWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: TextField(
                controller: _countryCodeController,
                maxLength: 3,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '+',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                controller: _phoneNumberController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () => _verifyPhoneNumber(context),
          child: Text('Submit'),
        )
      ],
    );
  }

  Widget _codeVerificationWidget(context, verifcationId) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _codeNumberController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: 'Enter Code sent on phone',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () => _verifySMS(
            context,
            verifcationId,
          ),
          child: Text('verify'),
        )
      ],
    );
  }

  void _verifyPhoneNumber(BuildContext context) {
    BlocProvider.of<PhoneAuthBloc>(context).add(PhoneAuthNumberVerified(
        phoneNumber:
            '\+' + _countryCodeController.text + _phoneNumberController.text));
  }

  void _verifySMS(BuildContext context, String verificationCode) {
    BlocProvider.of<PhoneAuthBloc>(context).add(PhoneAuthCodeVerified(
        verificationId: verificationCode, smsCode: _codeNumberController.text));
  }

  void _showSnackBarWithText(
      {@required BuildContext context, String textValue}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(textValue)));
  }
}
