import 'package:authentication_with_bloc/home/views/home_main_view.dart';
import 'package:authentication_with_bloc/login/views/login_main_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        body: PhoneAuthView(),
      ),
    );
  }
}

class PhoneAuthView extends StatefulWidget {
  @override
  _PhoneAuthViewState createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  bool isPhoneNumberSubmitted;
  bool isCodeVerified;
  String verificationCode;

  TextEditingController _countryCodeController;
  TextEditingController _phoneNumberController;
  TextEditingController _codeNumberController;

  @override
  void initState() {
    super.initState();
    isPhoneNumberSubmitted = false;
    isCodeVerified = false;
    _countryCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _codeNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return !isPhoneNumberSubmitted
        ? phoneNumberSubmitWidget()
        : codeVerificationWidget();
  }

  Widget phoneNumberSubmitWidget() {
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
          onPressed: _verifyPhoneNumber,
          child: Text('Submit'),
        )
      ],
    );
  }

  Widget codeVerificationWidget() {
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
          onPressed: _verifySMS,
          child: Text('verify'),
        )
      ],
    );
  }

  void _verifyPhoneNumber() async {
    final phoneNumber =
        ('\+' + _countryCodeController.text + _phoneNumberController.text);
    print(phoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verficationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
    setState(() {
      isPhoneNumberSubmitted = true;
    });
  }

  void _verifySMS() async {
    setState(() {
      isCodeVerified = true;
    });
    _signInWithPhoneNumber();
  }

  //* Setting some callback for firebase phone auth

  //If on android it will work
  Future<void> _verificationCompleted(PhoneAuthCredential credential) async {
    print('Verfication completed is called ');
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print('user have singed with ${userCredential.user.uid}');
  }

  Future<void> _verficationFailed(FirebaseException exception) async {
    print('Verificatiaon failed is called ${exception.toString()}');

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occured ${exception.toString()}')));
    setState(() {
      isPhoneNumberSubmitted = false;
    });
  }

  Future<void> _codeSent(String verficationId, int resendToken) async {
    print('Code sent is called with $verficationId and token $resendToken');
    setState(() {
      isPhoneNumberSubmitted = true;
      verificationCode = verficationId;
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP is sent to your mobile number ')));
  }

  Future<void> _codeAutoRetrievalTimeout(String verificationId) async {
    print(
        'Code auto retreival time out is called with verification id $verificationId');
  }

  //* For logging you in with phone number
  Future<void> _signInWithPhoneNumber() async {
    final code = _codeNumberController.text;

    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationCode,
      smsCode: (code == null || code.trim().length == 0) ? '123456' : code,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeMainView()));

    print('user have singed with ${userCredential.user.uid}');
  }
}
