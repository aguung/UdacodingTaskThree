import 'package:app_task/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;
  LoginCubit({this.repository}) : super(LoginInitial());

  void login(String email, String password) async {
    emit(LoadingLoginState());
    var result = await repository.signIn(email, password);
    result.fold(
          (errorMessage) => emit(FailureLoginState(errorMessage)),
          (user) => emit(SuccessLoginState(user)),
    );
  }
  void register(String email, String password) async {
    emit(LoadingLoginState());
    var result = await repository.signUp(email, password);
    result.fold(
          (errorMessage) => emit(FailureLoginState(errorMessage)),
          (user) => emit(SuccessLoginState(user)),
    );
  }
}
