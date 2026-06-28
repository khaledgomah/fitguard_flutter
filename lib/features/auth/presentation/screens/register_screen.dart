import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/network/api_exception.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_widgets.dart';
import '../widgets/auth_split_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String? _selectedSport;
  bool _isLoading = false;
  bool _hidePassword = true;
  String _errorMessage = '';

  final _sports = const [
    _SportOption('athletics', 'Athletics / Track'),
    _SportOption('basketball', 'Basketball'),
    _SportOption('cycling', 'Cycling'),
    _SportOption('football', 'Football / Soccer'),
    _SportOption('weightlifting', 'Olympic Weightlifting'),
    _SportOption('tennis', 'Tennis'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
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
      await widget.authController.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        sport: _selectedSport!,
        age: int.parse(_ageController.text.trim()),
        weight: double.parse(_weightController.text.trim()),
        height: double.parse(_heightController.text.trim()),
      );
      if (mounted) context.go(AppRoutes.dashboard);
    } catch (error) {
      setState(() {
        _errorMessage = error is ApiException
            ? error.message
            : 'Unable to create account. Please try again.';
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
            Text('Create Account', style: theme.textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              'Enter your details to configure your clinical profile.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            AuthSectionCard(
              title: 'Identity',
              icon: Icons.account_circle_outlined,
              children: [
                AuthTextField(
                  label: 'Full Legal Name',
                  controller: _nameController,
                  hintText: 'Alex Morgan',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: (value) => validateRequired(value, 'Name'),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'Professional Email',
                  controller: _emailController,
                  hintText: 'alex@team.com',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'Secure Password',
                  controller: _passwordController,
                  hintText: 'At least 6 characters',
                  prefixIcon: Icons.lock_outline,
                  validator: validatePassword,
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
              ],
            ),
            const SizedBox(height: 18),
            AuthSectionCard(
              title: 'Biometric Baseline',
              icon: Icons.monitor_heart_outlined,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedSport,
                  decoration: const InputDecoration(
                    labelText: 'Primary Discipline',
                    prefixIcon: Icon(Icons.fitness_center),
                  ),
                  items: _sports
                      .map(
                        (sport) => DropdownMenuItem<String>(
                          value: sport.value,
                          child: Text(sport.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedSport = value);
                  },
                  validator: (value) =>
                      value == null ? 'Please select a discipline' : null,
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 430;
                    final fields = [
                      _NumberField(
                        label: 'Age',
                        suffix: 'Yrs',
                        controller: _ageController,
                        validator: (value) => _validateNumber(
                          value,
                          'Age',
                          min: 1,
                          allowDecimal: false,
                        ),
                      ),
                      _NumberField(
                        label: 'Weight',
                        suffix: 'kg',
                        controller: _weightController,
                        validator: (value) =>
                            _validateNumber(value, 'Weight', min: 1),
                      ),
                      _NumberField(
                        label: 'Height',
                        suffix: 'cm',
                        controller: _heightController,
                        validator: (value) =>
                            _validateNumber(value, 'Height', min: 1),
                      ),
                    ];

                    if (isCompact) {
                      return Column(
                        children: [
                          for (final field in fields) ...[
                            field,
                            if (field != fields.last)
                              const SizedBox(height: 16),
                          ],
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final field in fields) ...[
                          Expanded(child: field),
                          if (field != fields.last) const SizedBox(width: 12),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            AuthErrorBanner(message: _errorMessage),
            if (_errorMessage.isNotEmpty) const SizedBox(height: 18),
            AuthSubmitButton(
              label: 'Create Account',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),
            Text(
              "By registering, you agree to FitGuard's Terms of Service and Privacy Policy.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Log in to Dashboard'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateNumber(
    String? value,
    String fieldName, {
    required num min,
    bool allowDecimal = true,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '$fieldName is required';

    final parsed = allowDecimal
        ? double.tryParse(trimmed)
        : int.tryParse(trimmed);
    if (parsed == null || parsed < min) {
      return 'Enter a valid $fieldName';
    }

    return null;
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.suffix,
    required this.controller,
    required this.validator,
  });

  final String label;
  final String suffix;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      decoration: InputDecoration(labelText: label, suffixText: suffix),
    );
  }
}

class _SportOption {
  const _SportOption(this.value, this.label);

  final String value;
  final String label;
}
