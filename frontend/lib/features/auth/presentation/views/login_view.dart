import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/auth/presentation/view_models/login_view_model.dart';

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
              child: Consumer<LoginViewModel>(
                builder: (context, vm, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo / Title
                    Icon(
                      Icons.calendar_month,
                      size: 80,
                      color: GirafColors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'GIRAF Ugeplan',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: GirafColors.orange,
                          ),
                    ),
                    const SizedBox(height: 48),

                    // Email field
                    TextField(
                      onChanged: vm.setEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextField(
                      onChanged: vm.setPassword,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => vm.login(),
                      decoration: const InputDecoration(
                        labelText: 'Adgangskode',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Remember me
                    Row(
                      children: [
                        Checkbox(
                          value: vm.rememberMe,
                          onChanged: (v) => vm.setRememberMe(v ?? false),
                          activeColor: GirafColors.orange,
                        ),
                        const Text('Husk mig'),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Error message
                    if (vm.error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GirafColors.lightRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          vm.error!,
                          style: const TextStyle(color: GirafColors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Login button
                    ElevatedButton(
                      onPressed: vm.isLoading ? null : vm.login,
                      child: vm.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Log ind'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
