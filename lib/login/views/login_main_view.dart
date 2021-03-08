import 'package:authentication_with_bloc/authenticaiton/bloc/authentication_bloc.dart';
import 'package:authentication_with_bloc/home/views/home_main_view.dart';
import 'package:authentication_with_bloc/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:authentication_with_bloc/phone_auth/data/provider/phone_auth_firebase_provider.dart';
import 'package:authentication_with_bloc/phone_auth/data/repositories/phone_auth_repository.dart';
import 'package:authentication_with_bloc/phone_auth/views/login_phone_number_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Builder(
          builder: (context) {
            return BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationSuccess) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeMainView()));
                } else if (state is AuthenticationFailiure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              buildWhen: (current, next) {
                if (next is AuthenticationSuccess) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is AuthenticationInitial ||
                    state is AuthenticationFailiure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () =>
                              BlocProvider.of<AuthenticationBloc>(context).add(
                            AuthenticationGoogleStarted(),
                          ),
                          child: Text('Login with Google'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => PhoneAuthBloc(
                                          phoneAuthRepository:
                                              PhoneAuthRepository(
                                            phoneAuthFirebaseProvider:
                                                PhoneAuthFirebaseProvider(
                                                    firebaseAuth:
                                                        FirebaseAuth.instance),
                                          ),
                                        ),
                                        child: LoginPhoneNumberView(),
                                      )),
                            );
                          },
                          child: Text('Login with Phone Number'),
                        ),
                      ],
                    ),
                  );
                } else if (state is AuthenticationLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Center(
                    child: Text('Undefined state : ${state.runtimeType}'));
              },
            );
          },
        ),
      ),
    );
  }
}
