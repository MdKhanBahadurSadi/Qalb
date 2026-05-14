import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/health_profile_form_provider.dart';
import '../providers/risk_prediction_provider.dart';
import '../widgets/ocr_scan_button.dart';
import '../../data/services/ocr_service.dart';

class HealthProfileFormScreen extends ConsumerStatefulWidget {
  const HealthProfileFormScreen({super.key});

  @override
  ConsumerState<HealthProfileFormScreen> createState() => _HealthProfileFormScreenState();
}

class _HealthProfileFormScreenState extends ConsumerState<HealthProfileFormScreen> {
  late TextEditingController _ageController;
  late TextEditingController _heightFeetController;
  late TextEditingController _heightInchesController;
  late TextEditingController _weightController;
  late TextEditingController _systolicBPController;
  late TextEditingController _diastolicBPController;
  late TextEditingController _cholesterolController;
  late TextEditingController _heartRateController;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(healthProfileFormProvider);
    _ageController = TextEditingController(text: initialState.age.toString());
    _heightFeetController = TextEditingController(text: initialState.heightFeet.toString());
    _heightInchesController = TextEditingController(text: initialState.heightInches.toString());
    _weightController = TextEditingController(text: initialState.weight.toString());
    _systolicBPController = TextEditingController(text: initialState.systolicBP.toString());
    _diastolicBPController = TextEditingController(text: initialState.diastolicBP.toString());
    _cholesterolController = TextEditingController(text: initialState.cholesterol.toString());
    _heartRateController = TextEditingController(text: initialState.heartRate.toString());
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightFeetController.dispose();
    _heightInchesController.dispose();
    _weightController.dispose();
    _systolicBPController.dispose();
    _diastolicBPController.dispose();
    _cholesterolController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(healthProfileFormProvider);
    final notifier = ref.read(healthProfileFormProvider.notifier);
    final theme = Theme.of(context);

    // Listen to state changes to update controllers (e.g. after OCR scan)
    ref.listen(healthProfileFormProvider, (previous, next) {
      if (int.tryParse(_ageController.text) != next.age) {
        _ageController.text = next.age.toString();
      }
      if (int.tryParse(_heightFeetController.text) != next.heightFeet) {
        _heightFeetController.text = next.heightFeet.toString();
      }
      if (int.tryParse(_heightInchesController.text) != next.heightInches) {
        _heightInchesController.text = next.heightInches.toString();
      }
      if (double.tryParse(_weightController.text) != next.weight) {
        _weightController.text = next.weight.toString();
      }
      if (int.tryParse(_systolicBPController.text) != next.systolicBP) {
        _systolicBPController.text = next.systolicBP.toString();
      }
      if (int.tryParse(_diastolicBPController.text) != next.diastolicBP) {
        _diastolicBPController.text = next.diastolicBP.toString();
      }
      if (int.tryParse(_cholesterolController.text) != next.cholesterol) {
        _cholesterolController.text = next.cholesterol.toString();
      }
      if (int.tryParse(_heartRateController.text) != next.heartRate) {
        _heartRateController.text = next.heartRate.toString();
      }
    });

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
              title: const Text('ফর্ম বন্ধ করবেন?'),
              content: const Text('আপনার বর্তমান তথ্যগুলো মুছে যাবে। আপনি কি নিশ্চিত?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('না'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red)),
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
        ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: formState.currentStep == index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // OCR Scan Button — always visible at the top
                  OcrScanButton(
                    onResultParsed: (OcrParsedResult result) {
                      // Auto-fill all extracted fields
                      notifier.updateField(
                        age: result.age,
                        weight: result.weight,
                        systolicBP: result.systolicBP,
                        diastolicBP: result.diastolicBP,
                        cholesterol: result.cholesterol,
                        heartRate: result.heartRate,
                        diabetes: result.hasDiabetes ? true : null,
                        smoking: result.hasSmoking ? true : null,
                        familyHistory: result.hasFamilyHistory ? true : null,
                      );
                      // If clinical data found, jump to step 2
                      if (result.systolicBP != null ||
                          result.cholesterol != null ||
                          result.heartRate != null) {
                        notifier.goToStep(1);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildStepContent(context, theme, formState, notifier),
                ],
              ),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('পিছনে'),
                    ),
                  ),
                if (formState.currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text: formState.currentStep == 2 ? 'রিস্ক হিসাব করুন' : 'পরবর্তী',
                    onPressed: () async {
                      if (formState.currentStep == 2) {
                        await ref.read(riskPredictionProvider.notifier).calculateRisk();
                        if (context.mounted) {
                          context.push('/risk-result');
                        }
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
        return _Step1BasicInfo(
          theme: theme,
          state: state,
          notifier: notifier,
          ageController: _ageController,
          heightFeetController: _heightFeetController,
          heightInchesController: _heightInchesController,
          weightController: _weightController,
        );
      case 1:
        return _Step2ClinicalInfo(
          theme: theme,
          state: state,
          notifier: notifier,
          systolicBPController: _systolicBPController,
          diastolicBPController: _diastolicBPController,
          cholesterolController: _cholesterolController,
          heartRateController: _heartRateController,
        );
      case 2:
        return _Step3History(theme: theme, state: state, notifier: notifier);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _Step1BasicInfo extends StatelessWidget {
  final ThemeData theme;
  final HealthProfileFormState state;
  final HealthProfileFormNotifier notifier;
  final TextEditingController ageController;
  final TextEditingController heightFeetController;
  final TextEditingController heightInchesController;
  final TextEditingController weightController;

  const _Step1BasicInfo({
    required this.theme,
    required this.state,
    required this.notifier,
    required this.ageController,
    required this.heightFeetController,
    required this.heightInchesController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('মৌলিক তথ্য', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildLabel(theme, 'বয়স'),
        TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'আপনার বয়স লিখুন',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) => notifier.updateField(age: int.tryParse(val)),
        ),
        const SizedBox(height: 20),
        _buildLabel(theme, 'লিঙ্গ'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('পুরুষ'),
                value: 'Male',
                groupValue: state.sex,
                onChanged: (val) => notifier.updateField(sex: val),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('মহিলা'),
                value: 'Female',
                groupValue: state.sex,
                onChanged: (val) => notifier.updateField(sex: val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildLabel(theme, 'উচ্চতা'),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: heightFeetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ফুট',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (val) => notifier.updateField(heightFeet: int.tryParse(val)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: heightInchesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ইঞ্চি',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (val) => notifier.updateField(heightInches: int.tryParse(val)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildLabel(theme, 'ওজন (kg)'),
        TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) => notifier.updateField(weight: double.tryParse(val)),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'উচ্চতা: ${state.heightInCm.toStringAsFixed(1)} সেমি',
                style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'আপনার BMI: ${state.bmi.toStringAsFixed(1)} (${state.bmiCategory})',
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
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
  final TextEditingController systolicBPController;
  final TextEditingController diastolicBPController;
  final TextEditingController cholesterolController;
  final TextEditingController heartRateController;

  const _Step2ClinicalInfo({
    required this.theme,
    required this.state,
    required this.notifier,
    required this.systolicBPController,
    required this.diastolicBPController,
    required this.cholesterolController,
    required this.heartRateController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ক্লিনিক্যাল তথ্য', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                theme,
                'সিস্টোলিক BP',
                systolicBPController,
                (v) => notifier.updateField(systolicBP: int.tryParse(v)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField(
                theme,
                'ডায়াস্টোলিক BP',
                diastolicBPController,
                (v) => notifier.updateField(diastolicBP: int.tryParse(v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          theme,
          'কোলেস্টেরল (mg/dL)',
          cholesterolController,
          (v) => notifier.updateField(cholesterol: int.tryParse(v)),
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          theme,
          'হার্ট রেট (bpm)',
          heartRateController,
          (v) => notifier.updateField(heartRate: int.tryParse(v)),
        ),
      ],
    );
  }
}

class _Step3History extends StatelessWidget {
  final ThemeData theme;
  final HealthProfileFormState state;
  final HealthProfileFormNotifier notifier;

  const _Step3History({required this.theme, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ইতিহাস ও অভ্যাস', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildSwitchTile(theme, 'ডায়াবেটিস আছে?', state.diabetes, (v) => notifier.updateField(diabetes: v)),
        _buildSwitchTile(theme, 'পরিবারে হার্টের রোগ আছে?', state.familyHistory, (v) => notifier.updateField(familyHistory: v)),
        _buildSwitchTile(theme, 'আপনি কি ধূমপান করেন?', state.smoking, (v) => notifier.updateField(smoking: v)),
      ],
    );
  }
}

// Helpers
Widget _buildLabel(ThemeData theme, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget _buildNumberField(ThemeData theme, String label, TextEditingController controller, Function(String) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(theme, label),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
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
    title: Text(title),
    value: value,
    onChanged: onChanged,
    activeColor: theme.colorScheme.primary,
  );
}
