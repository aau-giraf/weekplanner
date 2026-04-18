import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/auth/presentation/login_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_state.dart';

/// Login screen with username/password form, rendered as a centered
/// white card on the cream scaffold.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(GirafSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: const _LoginCard(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: GirafRadii.cardRadius,
        boxShadow: GirafElevation.card,
      ),
      padding: const EdgeInsets.all(GirafSpacing.xxl),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          final errorMessage = state is LoginFailure ? state.message : null;
          return _LoginForm(
            state: state,
            isLoading: isLoading,
            errorMessage: errorMessage,
          );
        },
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final LoginState state;
  final bool isLoading;
  final String? errorMessage;

  const _LoginForm({
    required this.state,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.asset(
            'assets/images/giraf_mascot.png',
            width: 96,
            height: 96,
          ),
        ),
        const SizedBox(height: GirafSpacing.md),
        Text(
          'GIRAF Ugeplan',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: context.colorScheme.primary,
              ),
        ),
        const SizedBox(height: GirafSpacing.xs),
        Text(
          'Log ind for at fortsætte',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: GirafSpacing.xl),
        TextField(
          onChanged: context.read<LoginCubit>().emailChanged,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Brugernavn',
            prefixIcon: Icon(Icons.person_outlined),
          ),
        ),
        const SizedBox(height: GirafSpacing.md),
        const _PasswordField(),
        const SizedBox(height: GirafSpacing.sm),
        _RememberAndForgotRow(rememberMe: state.rememberMe),
        if (errorMessage != null) ...[
          const SizedBox(height: GirafSpacing.md),
          _ErrorBanner(message: errorMessage!),
        ],
        const SizedBox(height: GirafSpacing.lg),
        FilledButton(
          onPressed: isLoading
              ? null
              : () => context.read<LoginCubit>().loginSubmitted(),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colorScheme.onPrimary,
                  ),
                )
              : const Text('Log ind'),
        ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField();

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: context.read<LoginCubit>().passwordChanged,
      obscureText: _obscure,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => context.read<LoginCubit>().loginSubmitted(),
      decoration: InputDecoration(
        labelText: 'Adgangskode',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscure = !_obscure),
          tooltip: _obscure ? 'Vis' : 'Skjul',
        ),
      ),
    );
  }
}

class _RememberAndForgotRow extends StatelessWidget {
  final bool rememberMe;
  const _RememberAndForgotRow({required this.rememberMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (v) =>
              context.read<LoginCubit>().rememberMeChanged(v ?? false),
        ),
        const Text('Husk mig'),
        const Spacer(),
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Endnu ikke tilgængelig')),
          ),
          child: const Text('Glemt kode?'),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GirafSpacing.md),
      decoration: BoxDecoration(
        color: context.girafColors.errorBackground,
        borderRadius: GirafRadii.inputRadius,
      ),
      child: Text(
        message,
        style: TextStyle(color: context.colorScheme.error),
        textAlign: TextAlign.center,
      ),
    );
  }
}
