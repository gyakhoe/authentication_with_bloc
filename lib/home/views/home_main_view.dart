import 'package:authentication_with_bloc/authenticaiton/bloc/authentication_bloc.dart';
import 'package:authentication_with_bloc/login/views/login_main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationExited(),
              ),
            ),
          ],
        ),
        body: Center(
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationFailiure) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => LoginMainView()));
              }
            },
            builder: (context, state) {
              if (state is AuthenticationInitial) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationStarted());
                return CircularProgressIndicator();
              } else if (state is AuthenticationLoading) {
                return CircularProgressIndicator();
              } else if (state is AuthenticationSuccess) {
                return Text('Welcome :${state.authenticationDetail.uid}');
              }
              return Text('Undefined state : ${state.runtimeType}');
            },
          ),
        ),
      ),
    );
  }
}
