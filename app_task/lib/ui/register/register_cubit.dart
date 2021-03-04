import 'package:app_task/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository repository;

  RegisterCubit({this.repository}) : super(RegisterInitial());

  void register(String email, String password) async {
    emit(LoadingRegisterState());
    var result = await repository.signUp(email, password);
    result.fold(
      (errorMessage) => emit(FailureRegisterState(errorMessage)),
      (user) => emit(SuccessRegisterState(user)),
    );
  }
}
