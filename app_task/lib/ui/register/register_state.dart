part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class SuccessRegisterState extends RegisterState {
  final User user;
  SuccessRegisterState(this.user);
  @override
  List<Object> get props => [user];
}

class LoadingRegisterState extends RegisterState {}

class FailureRegisterState extends RegisterState {
  final String errorMessage;

  FailureRegisterState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'FailureLoginState{errorMessage: $errorMessage}';
  }
}
