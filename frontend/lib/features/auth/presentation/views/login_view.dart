import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/auth/presentation/login_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_state.dart';

/// Login screen with email/password form.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final isLoading = state is LoginLoading;
                  final errorMessage =
                      state is LoginFailure ? state.message : null;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 80,
                        color: context.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'GIRAF Ugeplan',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 48),
                      TextField(
                        onChanged: context.read<LoginCubit>().emailChanged,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Brugernavn',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: context.read<LoginCubit>().passwordChanged,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) =>
                            context.read<LoginCubit>().loginSubmitted(),
                        decoration: const InputDecoration(
                          labelText: 'Adgangskode',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: state.rememberMe,
                            onChanged: (v) => context
                                .read<LoginCubit>()
                                .rememberMeChanged(v ?? false),
                            activeColor: context.colorScheme.primary,
                          ),
                          const Text('Husk mig'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.girafColors.errorBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: context.colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () =>
                                context.read<LoginCubit>().loginSubmitted(),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary,
                                ),
                              )
                            : const Text('Log ind'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
