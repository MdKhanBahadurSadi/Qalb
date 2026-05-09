import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/health_profile_form_provider.dart';

class HealthProfileFormScreen extends ConsumerWidget {
  const HealthProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(healthProfileFormProvider);
    final notifier = ref.read(healthProfileFormProvider.notifier);
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        if (formState.currentStep > 0) {
          notifier.previousStep();
        } else {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              title: Text('ফর্ম বন্ধ করবেন?', style: theme.textTheme.titleLarge),
              content: Text('আপনার বর্তমান তথ্যগুলো মুছে যাবে। আপনি কি নিশ্চিত?', style: theme.textTheme.bodyMedium),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('না', style: TextStyle(color: theme.colorScheme.primary)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('হ্যাঁ', style: TextStyle(color: theme.colorScheme.error)),
                ),
              ],
            ),
          );
          
          if (shouldPop ?? false) {
            if (context.mounted) context.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('স্বাস্থ্য প্রোফাইল'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: formState.currentStep == index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'ধাপ ${formState.currentStep + 1} / ৪',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStepContent(context, theme, formState, notifier),
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                if (formState.currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => notifier.previousStep(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 56),
                        side: BorderSide(color: theme.colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('পিছনে', style: TextStyle(color: theme.colorScheme.primary)),
                    ),
                  ),
                if (formState.currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text: formState.currentStep == 3 ? 'রিস্ক হিসাব করুন' : 'পরবর্তী',
                    onPressed: () {
                      if (formState.currentStep == 3) {
                        context.push('/risk-result');
                      } else {
                        notifier.nextStep();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStepContent(BuildContext context, ThemeData theme, HealthProfileFormState state,
      HealthProfileFormNotifier notifier) {
    switch (state.currentStep) {
      case 0:
        return _Step1BasicInfo(theme: theme, state: state, notifier: notifier);
      case 1:
        return _Step2ClinicalInfo(theme: theme, state: state, notifier: notifier);
      case 2:
        return _Step3Lifestyle(theme: theme, state: state, notifier: notifier);
      case 3:
        return _Step4MedicalHistory(theme: theme, state: state, notifier: notifier);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _Step1BasicInfo extends StatelessWidget {
  final ThemeData theme;
  final HealthProfileFormState state;
  final HealthProfileFormNotifier notifier;

  const _Step1BasicInfo({required this.theme, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('মৌলিক তথ্য',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildLabel(theme, 'বয়স'),
        TextField(
          keyboardType: TextInputType.number,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'আপনার বয়স লিখুন',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) =>
              notifier.updateField(age: int.tryParse(val) ?? state.age),
        ),
        const SizedBox(height: 20),
        _buildLabel(theme, 'লিঙ্গ'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('পুরুষ', style: theme.textTheme.bodyMedium),
                value: 'Male',
                groupValue: state.sex,
                activeColor: theme.colorScheme.primary,
                onChanged: (val) => notifier.updateField(sex: val),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('মহিলা', style: theme.textTheme.bodyMedium),
                value: 'Female',
                groupValue: state.sex,
                activeColor: theme.colorScheme.primary,
                onChanged: (val) => notifier.updateField(sex: val),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(theme, 'উচ্চতা (cm)'),
                  TextField(
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => notifier.updateField(
                        height: double.tryParse(val) ?? state.height),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(theme, 'ওজন (kg)'),
                  TextField(
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => notifier.updateField(
                        weight: double.tryParse(val) ?? state.weight),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.monitor_weight, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'আপনার BMI: ${state.bmi.toStringAsFixed(1)} (${state.bmiCategory})',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Step2ClinicalInfo extends StatelessWidget {
  final ThemeData theme;
  final HealthProfileFormState state;
  final HealthProfileFormNotifier notifier;

  const _Step2ClinicalInfo({required this.theme, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ক্লিনিক্যাল তথ্য',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildNumberField(theme, 'সিস্টোলিক BP (mmHg)', (v) => notifier.updateField(systolicBP: int.tryParse(v)))),
            const SizedBox(width: 16),
            Expanded(child: _buildNumberField(theme, 'ডায়াস্টোলিক BP (mmHg)', (v) => notifier.updateField(diastolicBP: int.tryParse(v)))),
          ],
        ),
        const SizedBox(height: 20),
        _buildLabelWithInfo(theme, 'কোলেস্টেরল (mg/dL)', 'সাম্প্রতিক রক্ত পরীক্ষার রিপোর্ট থেকে নিন'),
        TextField(
          keyboardType: TextInputType.number,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) => notifier.updateField(cholesterol: int.tryParse(val)),
        ),
        const SizedBox(height: 20),
        _buildNumberField(theme, 'রেস্টিং হার্ট রেট (bpm)', (v) => notifier.updateField(heartRate: int.tryParse(v))),
        const SizedBox(height: 20),
        _buildNumberField(theme, 'ট্রাইগ্লিসারাইড (mg/dL)', (v) => notifier.updateField(triglycerides: int.tryParse(v))),
      ],
    );
  }
}

class _Step3Lifestyle extends StatelessWidget {
  final ThemeData theme;
  final HealthProfileFormState state;
  final HealthProfileFormNotifier notifier;

  const _Step3Lifestyle({required this.theme, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('জীবনযাপন',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildSwitchTile(theme, 'ধূমপান করেন?', state.smoking, (v) => notifier.updateField(smoking: v)),
        _buildSwitchTile(theme, 'মদ্যপান করেন?', state.alcoholConsumption, (v) => notifier.updateField(alcoholConsumption: v)),
        const SizedBox(height: 20),
        _buildSlider(theme, 'সাপ্তাহিক ব্যায়াম (ঘণ্টা)', state.exerciseHoursPerWeek, 0, 20, (v) => notifier.updateField(exerciseHoursPerWeek: v)),
        _buildSlider(theme, 'দৈনিক বসে থাকার সময় (ঘণ্টা)', state.sedentaryHoursPerDay, 0, 24, (v) => notifier.updateField(sedentaryHoursPerDay: v)),
        _buildSlider(theme, 'সাপ্তাহিক সক্রিয় দিন', state.physicalActivityDaysPerWeek.toDouble(), 0, 7, (v) => notifier.updateField(physicalActivityDaysPerWeek: v.toInt())),
        _buildSlider(theme, 'দৈনিক ঘুম (ঘণ্টা)', state.sleepHoursPerDay.toDouble(), 4, 12, (v) => notifier.updateField(sleepHoursPerDay: v.toInt())),
        _buildSlider(theme, 'মানসিক চাপের মাত্রা', state.stressLevel.toDouble(), 1, 10, (v) => notifier.updateField(stressLevel: v.toInt())),
        const SizedBox(height: 20),
        _buildLabel(theme, 'খাদ্যাভ্যাস'),
        DropdownButtonFormField<String>(
          value: state.diet,
          style: theme.textTheme.bodyLarge,
          dropdownColor: theme.colorScheme.surface,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: const [
            DropdownMenuItem(value: 'Healthy', child: Text('স্বাস্থ্যকর')),
            DropdownMenuItem(value: 'Average', child: Text('মাঝারি')),
            DropdownMenuItem(value: 'Unhealthy', child: Text('অস্বাস্থ্যকর')),
          ],
          onChanged: (val) => notifier.updateField(diet: val),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _Step4MedicalHistory extends StatelessWidget {
  final ThemeData theme;
  final HealthProfileFormState state;
  final HealthProfileFormNotifier notifier;

  const _Step4MedicalHistory({required this.theme, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('চিকিৎসা ইতিহাস',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildSwitchTile(theme, 'ডায়াবেটিস আছে?', state.diabetes, (v) => notifier.updateField(diabetes: v)),
        _buildSwitchTile(theme, 'পরিবারে হার্টের রোগ?', state.familyHistory, (v) => notifier.updateField(familyHistory: v)),
        _buildSwitchTile(theme, 'আগে হার্টের সমস্যা?', state.previousHeartProblems, (v) => notifier.updateField(previousHeartProblems: v)),
        _buildSwitchTile(theme, 'বর্তমানে ওষুধ খাচ্ছেন?', state.medicationUse, (v) => notifier.updateField(medicationUse: v)),
        _buildSwitchTile(theme, 'স্থূলকায়?', state.obesity, (v) => notifier.updateField(obesity: v)),
      ],
    );
  }
}

// Helper Widgets
Widget _buildLabel(ThemeData theme, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
  );
}

Widget _buildLabelWithInfo(ThemeData theme, String text, String info) {
  return Row(
    children: [
      Text(text, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(width: 8),
      Tooltip(
        message: info,
        triggerMode: TooltipTriggerMode.tap,
        child: Icon(Icons.info_outline, size: 18, color: theme.colorScheme.onSurfaceVariant),
      ),
    ],
  );
}

Widget _buildNumberField(ThemeData theme, String label, Function(String) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(theme, label),
      TextField(
        keyboardType: TextInputType.number,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: onChanged,
      ),
    ],
  );
}

Widget _buildSwitchTile(ThemeData theme, String title, bool value, Function(bool) onChanged) {
  return SwitchListTile(
    title: Text(title, style: theme.textTheme.bodyLarge),
    value: value,
    onChanged: onChanged,
    contentPadding: EdgeInsets.zero,
    activeColor: theme.colorScheme.primary,
  );
}

Widget _buildSlider(ThemeData theme, String label, double value, double min, double max, Function(double) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLabel(theme, label),
          Text(
            value.toStringAsFixed(0), 
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
          ),
        ],
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        divisions: (max - min).toInt() > 0 ? (max - min).toInt() : 1,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
        inactiveColor: theme.colorScheme.primary.withOpacity(0.2),
      ),
    ],
  );
}
