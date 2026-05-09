import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/sunnah_diet_provider.dart';

class SunnahDietPlannerScreen extends ConsumerStatefulWidget {
  const SunnahDietPlannerScreen({super.key});

  @override
  ConsumerState<SunnahDietPlannerScreen> createState() => _SunnahDietPlannerScreenState();
}

class _SunnahDietPlannerScreenState extends ConsumerState<SunnahDietPlannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final _bpController = TextEditingController();
  String _diabetes = 'নেই';
  String _smoking = 'কখনো না';
  String _lifestyle = 'মাঝারি সক্রিয়';

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _cholesterolController.dispose();
    _bpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dietState = ref.watch(sunnahDietProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('AI সুন্নাহ ডায়েট প্ল্যানার', style: GoogleFonts.hindSiliguri()),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: dietState.when(
        data: (plan) => plan == null ? _buildForm(theme) : _buildResult(theme, plan),
        loading: () => Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
        error: (err, stack) => Center(child: Text('ত্রুটি: $err', style: theme.textTheme.bodyMedium)),
      ),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আপনার স্বাস্থ্য তথ্য দিন',
              style: GoogleFonts.hindSiliguri(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(theme, _ageController, 'বয়স', Icons.cake),
            _buildTextField(theme, _weightController, 'ওজন (কেজি)', Icons.monitor_weight),
            _buildTextField(theme, _cholesterolController, 'কোলেস্টেরল লেভেল (যদি জানা থাকে)', Icons.favorite_border),
            _buildTextField(theme, _bpController, 'রক্তচাপ (BP)', Icons.speed),
            
            const SizedBox(height: 16),
            _buildDropdown(theme, 'ডায়াবেটিস আছে?', ['নেই', 'আছে'], (val) => setState(() => _diabetes = val!)),
            _buildDropdown(theme, 'ধূমপানের ইতিহাস', ['কখনো না', 'প্রাক্তন ধূমপায়ী', 'বর্তমান ধূমপায়ী'], (val) => setState(() => _smoking = val!)),
            _buildDropdown(theme, 'লাইফস্টাইল', ['বসা কাজ', 'মাঝারি সক্রিয়', 'খুব সক্রিয়'], (val) => setState(() => _lifestyle = val!)),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              style: theme.elevatedButtonTheme.style,
              child: Text(
                'ডায়েট প্ল্যান তৈরি করুন', 
                style: GoogleFonts.hindSiliguri(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(ThemeData theme, TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDropdown(ThemeData theme, String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
        dropdownColor: theme.colorScheme.surface,
        style: theme.textTheme.bodyLarge,
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
        value: items.first,
      ),
    );
  }

  Widget _buildResult(ThemeData theme, String plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                plan,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15, 
                  height: 1.6,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => ref.refresh(sunnahDietProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('নতুন করে তথ্য দিন'),
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }

  void _submit() {
    ref.read(sunnahDietProvider.notifier).generatePlan(
      age: _ageController.text,
      weight: _weightController.text,
      cholesterol: _cholesterolController.text,
      bp: _bpController.text,
      diabetes: _diabetes,
      smoking: _smoking,
      lifestyle: _lifestyle,
    );
  }
}
