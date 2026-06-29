import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/profile_repository.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        authController: authController,
        profileRepository: ProfileRepository(
          dio: Dio(BaseOptions(
            baseUrl: 'http://10.0.2.2:5000',
            headers: {
              'Authorization': 'Bearer ${authController.session?.accessToken ?? ''}'
            }
          ))
        ),
      ),
      child: _EditProfileForm(authController: authController),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm({required this.authController});
  final AuthController authController;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _sportController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    final user = widget.authController.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _sportController = TextEditingController(text: user?.sport ?? '');
    _ageController = TextEditingController(text: user?.age.toString() ?? '');
    _weightController = TextEditingController(text: user?.weight.toString() ?? '');
    _heightController = TextEditingController(text: user?.height.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _sportController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        sport: _sportController.text,
        age: int.tryParse(_ageController.text),
        weight: double.tryParse(_weightController.text),
        height: double.tryParse(_heightController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile updated successfully!'),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message), 
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdating;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              children: [
                _buildModernTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  theme: theme,
                  enabled: !isLoading,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                
                _buildModernTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  theme: theme,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty || !value.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                
                _buildModernTextField(
                  controller: _sportController,
                  label: 'Primary Sport',
                  icon: Icons.sports_tennis,
                  theme: theme,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildModernTextField(
                        controller: _ageController,
                        label: 'Age',
                        icon: Icons.cake,
                        theme: theme,
                        keyboardType: TextInputType.number,
                        enabled: !isLoading,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernTextField(
                        controller: _weightController,
                        label: 'Weight (kg)',
                        icon: Icons.monitor_weight_outlined,
                        theme: theme,
                        keyboardType: TextInputType.number,
                        enabled: !isLoading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildModernTextField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  icon: Icons.height,
                  theme: theme,
                  keyboardType: TextInputType.number,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 40),
                
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isLoading)
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                    ],
                  ),
                  child: FilledButton(
                    onPressed: isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading 
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.outline),
        prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7)),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
