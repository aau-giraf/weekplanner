import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_state.dart';

final _log = Logger('LoginCubit');

/// Manages login form state and submission.
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final AuthCubit _authCubit;

  LoginCubit({
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        _authCubit = authCubit,
        super(const LoginInitial());

  /// Update the email field value.
  void emailChanged(String value) {
    emit(LoginInitial(
      email: value,
      password: state.password,
      rememberMe: state.rememberMe,
    ));
  }

  /// Update the password field value.
  void passwordChanged(String value) {
    emit(LoginInitial(
      email: state.email,
      password: value,
      rememberMe: state.rememberMe,
    ));
  }

  /// Toggle the remember-me preference.
  void rememberMeChanged(bool value) {
    emit(LoginInitial(
      email: state.email,
      password: state.password,
      rememberMe: value,
    ));
  }

  /// Validate and submit the login form.
  Future<void> loginSubmitted() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(LoginFailure(
        message: 'Udfyld venligst brugernavn og adgangskode',
        email: state.email,
        password: state.password,
        rememberMe: state.rememberMe,
      ));
      return;
    }

    emit(LoginLoading(
      email: state.email,
      password: state.password,
      rememberMe: state.rememberMe,
    ));

    final result =
        await _authRepository.login(state.email, state.password);

    switch (result) {
      case Left(:final value):
        emit(LoginFailure(
          message: value.message,
          email: state.email,
          password: state.password,
          rememberMe: state.rememberMe,
        ));
      case Right(:final value):
        _authCubit.authenticated(value.access);

        if (state.rememberMe) {
          final saveResult = await _authRepository.saveCredentials(
            state.email,
            state.password,
          );
          saveResult.fold(
            (failure) => _log
                .warning('Failed to save credentials: ${failure.message}'),
            (_) {},
          );
        } else {
          await _authRepository.clearSavedCredentials();
        }

        emit(LoginSuccess(
          email: state.email,
          password: state.password,
          rememberMe: state.rememberMe,
        ));
    }
  }
}
