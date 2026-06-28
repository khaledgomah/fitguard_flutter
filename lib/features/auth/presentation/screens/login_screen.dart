import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/network/api_exception.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_widgets.dart';
import '../widgets/auth_split_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _hidePassword = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await widget.authController.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) context.go(AppRoutes.dashboard);
    } catch (error) {
      setState(() {
        _errorMessage = error is ApiException
            ? error.message
            : 'Unable to login. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AuthSplitLayout(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthMobileBrand(),
            Text('Welcome Back', style: theme.textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              'Enter your credentials to access your dashboard.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 34),
            AuthTextField(
              label: 'Email Address',
              controller: _emailController,
              hintText: 'your@email.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: validateEmail,
            ),
            const SizedBox(height: 18),
            AuthTextField(
              label: 'Password',
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock_outline,
              textInputAction: TextInputAction.done,
              validator: (value) => validatePassword(value, minLength: 1),
              obscureText: _hidePassword,
              suffixIcon: IconButton(
                tooltip: _hidePassword ? 'Show password' : 'Hide password',
                onPressed: () {
                  setState(() => _hidePassword = !_hidePassword);
                },
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.forgotPassword),
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 8),
            AuthErrorBanner(message: _errorMessage),
            if (_errorMessage.isNotEmpty) const SizedBox(height: 18),
            AuthSubmitButton(
              label: 'Login',
              isLoading: _isLoading,
              onPressed: _submit,
              icon: Icons.login,
            ),
            const SizedBox(height: 28),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.register),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
