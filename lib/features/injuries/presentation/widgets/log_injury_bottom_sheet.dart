import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/create_injury_dto.dart';
import '../cubit/injury_cubit.dart';
import '../cubit/injury_state.dart';

class LogInjuryBottomSheet extends StatefulWidget {
  const LogInjuryBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LogInjuryBottomSheet(),
    );
  }

  @override
  State<LogInjuryBottomSheet> createState() => _LogInjuryBottomSheetState();
}

class _LogInjuryBottomSheetState extends State<LogInjuryBottomSheet> {
  String _muscleGroup = 'Hamstring';
  String _injuryType = 'Strain';
  String _severity = 'moderate';
  final DateTime _dateOccurred = DateTime.now();

  final List<String> _muscleGroups = [
    'Hamstring',
    'Knee',
    'Shoulder',
    'Ankle',
    'Lower Back',
    'Quadriceps',
    'Calf',
    'Groin',
  ];

  final List<String> _injuryTypes = [
    'Strain',
    'Sprain',
    'Tear',
    'Contusion',
    'Fracture',
    'Tendonitis',
    'Dislocation',
  ];

  final List<String> _severities = ['mild', 'moderate', 'severe'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<InjuryCubit, InjuryState>(
      listener: (context, state) {
        if (state is InjurySuccess) {
          Navigator.pop(context, true);
        } else if (state is InjuryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: bottomPadding + 24,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Log New Injury',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Record your injury details to track recovery progress.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 24),
              _buildDropdown(
                'Muscle Group',
                _muscleGroups,
                _muscleGroup,
                (v) => setState(() => _muscleGroup = v!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Injury Type',
                _injuryTypes,
                _injuryType,
                (v) => setState(() => _injuryType = v!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Severity',
                _severities,
                _severity,
                (v) => setState(() => _severity = v!),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: state is InjuryLoading
                    ? null
                    : () {
                        context.read<InjuryCubit>().createInjury(
                              CreateInjuryDto(
                                muscleGroup: _muscleGroup,
                                injuryType: _injuryType,
                                severity: _severity,
                                dateOccurred: _dateOccurred,
                              ),
                            );
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: state is InjuryLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Log Injury'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
