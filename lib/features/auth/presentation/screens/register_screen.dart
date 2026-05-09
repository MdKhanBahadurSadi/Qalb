import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isTermsAgreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_isTermsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('শর্তাবলিতে সম্মত হওয়া প্রয়োজন')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      await ref.read(authNotifierProvider.notifier).signUp(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
          );
      
      final authState = ref.read(authNotifierProvider);
      if (authState.hasError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.error.toString())),
          );
        }
      } else {
        if (mounted) {
          context.go('/home/dashboard');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('নিবন্ধন')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আপনার তথ্য দিয়ে নিবন্ধন করুন',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'নাম',
                  hint: 'আপনার পুরো নাম লিখুন',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'নাম প্রয়োজন';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'ইমেইল',
                  hint: 'আপনার ইমেইল দিন',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'ইমেইল প্রয়োজন';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'সঠিক ইমেইল দিন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'পাসওয়ার্ড',
                  hint: 'পাসওয়ার্ড দিন',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'পাসওয়ার্ড প্রয়োজন';
                    if (value.length < 6) return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'পাসওয়ার্ড নিশ্চিত করুন',
                  hint: 'আবার পাসওয়ার্ড দিন',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_reset),
                  validator: (value) {
                    if (value != _passwordController.text) return 'পাসওয়ার্ড মিলেনি';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isTermsAgreed,
                      onChanged: (value) => setState(() => _isTermsAgreed = value ?? false),
                      activeColor: theme.colorScheme.primary,
                    ),
                    Expanded(
                      child: Text(
                        'আমি শর্তাবলি এবং গোপনীয়তা নীতিতে সম্মত',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'নিবন্ধন সম্পন্ন করুন',
                  onPressed: _register,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('ইতোমধ্যে অ্যাকাউন্ট আছে? লগইন করুন'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
