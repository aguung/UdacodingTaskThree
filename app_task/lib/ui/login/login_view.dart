import 'package:app_task/repository/auth_repository.dart';
import 'package:app_task/ui/home/home_view.dart';
import 'package:app_task/ui/register/register_view.dart';
import 'package:app_task/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_cubit.dart';

class LoginView extends StatelessWidget {
  final formState = GlobalKey<FormState>();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final loginCubit = LoginCubit(repository: AuthRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginCubit>(
        create: (context) => loginCubit,
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is FailureLoginState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is SuccessLoginState) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomeView()));
            }
          },
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height),
              child: Stack(
                children: [
                  Form(
                    key: formState,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                            child: Image.asset(
                              "images/icon.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: controllerUsername,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              return value.isEmpty
                                  ? 'Email is empty'
                                  : value.isValidEmail()
                                      ? null
                                      : "Check your format email";
                            },
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerPassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                value.isEmpty ? 'Password is empty' : null,
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Login'),
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(16.0),
                                ),
                              ),
                              onPressed: () {
                                if (formState.currentState.validate()) {
                                  var username = controllerUsername.text.trim();
                                  var password = controllerPassword.text.trim();
                                  loginCubit.login(username, password);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: <Widget>[
                                Text('Does not have account?'),
                                TextButton(
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    bool result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterView()));
                                    if (result != null && result) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Register Succesfull'),
                                      ));
                                    }
                                  },
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                    if (state is LoadingLoginState) {
                      return Container(
                        color: Colors.black.withOpacity(.5),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
