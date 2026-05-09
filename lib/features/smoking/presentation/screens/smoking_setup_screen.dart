import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qalb/features/smoking/domain/entities/smoking_profile.dart';
import 'package:qalb/features/smoking/presentation/providers/smoking_provider.dart';

class SmokingSetupScreen extends ConsumerStatefulWidget {
  const SmokingSetupScreen({super.key});

  @override
  ConsumerState<SmokingSetupScreen> createState() => _SmokingSetupScreenState();
}

class _SmokingSetupScreenState extends ConsumerState<SmokingSetupScreen> {
  bool? _isSmoker;
  final _cigarettesController = TextEditingController();
  final _yearsController = TextEditingController();
  DateTime? _selectedQuitDate;

  @override
  void dispose() {
    _cigarettesController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_isSmoker == false) {
      ref.read(smokingProvider.notifier).updateProfile(
            const SmokingProfile(isCurrentSmoker: false, isInRecovery: false),
          );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home/dashboard');
      }
      return;
    }

    final cigarettes = int.tryParse(_cigarettesController.text) ?? 0;
    final years = int.tryParse(_yearsController.text) ?? 0;

    if (cigarettes == 0 || years == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('দয়া করে সঠিক তথ্য দিন')),
      );
      return;
    }

    ref.read(smokingProvider.notifier).updateProfile(
          SmokingProfile(
            isCurrentSmoker: true,
            cigarettesPerDay: cigarettes,
            yearsSmoked: years,
            quitDate: _selectedQuitDate,
            isInRecovery: _selectedQuitDate != null,
          ),
        );

    if (_selectedQuitDate != null) {
      context.go('/home/smoking');
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ধূমপান মুক্ত জীবন'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildQuestionCard(
              theme,
              'আপনি কি ধূমপান করেন?',
              child: Row(
                children: [
                  Expanded(
                    child: _ChoiceButton(
                      label: 'হ্যাঁ',
                      isSelected: _isSmoker == true,
                      onTap: () => setState(() => _isSmoker = true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ChoiceButton(
                      label: 'না',
                      isSelected: _isSmoker == false,
                      onTap: () => setState(() => _isSmoker = false),
                    ),
                  ),
                ],
              ),
            ),
            if (_isSmoker == true) ...[
              const SizedBox(height: 24),
              _buildInputCard(
                theme,
                'প্রতিদিন গড়ে কয়টি সিগারেট পান করেন?',
                controller: _cigarettesController,
                suffix: 'টি',
              ),
              const SizedBox(height: 16),
              _buildInputCard(
                theme,
                'কত বছর ধরে ধূমপান করছেন?',
                controller: _yearsController,
                suffix: 'বছর',
              ),
              const SizedBox(height: 24),
              Text(
                'আপনার লক্ষ্য কি?',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: Colors.green.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.green.withOpacity(0.2)),
                ),
                leading: const Icon(Icons.bolt, color: Colors.green),
                title: const Text('আজই ছাড়তে চাই'),
                onTap: () {
                  setState(() => _selectedQuitDate = DateTime.now());
                  _saveAndContinue();
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: Colors.blue.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.withOpacity(0.2)),
                ),
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: Text(_selectedQuitDate == null
                    ? 'আমি ইতোমধ্যে ছেড়েছি'
                    : 'ছেড়েছি: ${DateFormat('dd MMM, yyyy').format(_selectedQuitDate!)}'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _selectedQuitDate = date);
                  }
                },
              ),
            ],
            const SizedBox(height: 40),
            if (_isSmoker != null)
              ElevatedButton(
                onPressed: _saveAndContinue,
                style: theme.elevatedButtonTheme.style,
                child: const Text('চালিয়ে যান', style: TextStyle(fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(ThemeData theme, String question, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question, 
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildInputCard(ThemeData theme, String question, {required TextEditingController controller, required String suffix}) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question, 
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                suffixText: suffix,
                suffixStyle: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? colorScheme.primary : Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
