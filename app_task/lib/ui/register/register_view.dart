import 'package:app_task/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_task/utils/extensions.dart';
import 'register_cubit.dart';

class RegisterView extends StatelessWidget {
  final formState = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final registerCubit = RegisterCubit(repository: AuthRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RegisterCubit>(
        create: (context) => registerCubit,
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is FailureRegisterState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is SuccessRegisterState) {
              Navigator.pop(context, true);
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
                            height: MediaQuery.of(context).size.height / 4,
                            child: Image.asset(
                              "images/icon.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: controllerEmail,
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
                                      : "Check your email";
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
                              child: Text('Register'),
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(16.0),
                                ),
                              ),
                              onPressed: () {
                                if (formState.currentState.validate()) {
                                  var email = controllerEmail.text.trim();
                                  var password = controllerPassword.text.trim();
                                  registerCubit.register(email, password);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                    if (state is LoadingRegisterState) {
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
