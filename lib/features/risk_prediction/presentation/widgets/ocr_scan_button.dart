import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/ocr_provider.dart';
import '../../data/services/ocr_service.dart';

/// A premium "Scan Report" button + bottom sheet for OCR auto-fill
class OcrScanButton extends ConsumerWidget {
  final void Function(OcrParsedResult result) onResultParsed;

  const OcrScanButton({super.key, required this.onResultParsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrState = ref.watch(ocrProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showSourcePicker(context, ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: ocrState.isLoading
                ? [
                    theme.colorScheme.primary.withValues(alpha: 0.5),
                    theme.colorScheme.tertiary.withValues(alpha: 0.5),
                  ]
                : [
                    theme.colorScheme.primary.withValues(alpha: 0.15),
                    theme.colorScheme.tertiary.withValues(alpha: 0.10),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ocrState.isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            else
              Icon(Icons.document_scanner_rounded,
                  color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 10),
            Text(
              ocrState.isLoading ? 'স্ক্যান করছে...' : '📋 রিপোর্ট স্ক্যান করুন',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'AUTO FILL',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSourcePicker(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'মেডিকেল রিপোর্ট স্ক্যান করুন',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'রক্তচাপ, কোলেস্টেরল, হার্ট রেট স্বয়ংক্রিয়ভাবে পূরণ হবে',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SourceTile(
                    icon: Icons.camera_alt_rounded,
                    label: 'ক্যামেরা দিয়ে তুলুন',
                    subtitle: 'সরাসরি রিপোর্টের ছবি তুলুন',
                    color: theme.colorScheme.primary,
                    onTap: () {
                      Navigator.pop(context);
                      _scan(context, ref, ImageSource.camera);
                    },
                  ),
                  const SizedBox(height: 12),
                  _SourceTile(
                    icon: Icons.photo_library_rounded,
                    label: 'গ্যালারি থেকে বেছে নিন',
                    subtitle: 'আগে তোলা রিপোর্টের ছবি',
                    color: theme.colorScheme.secondary,
                    onTap: () {
                      Navigator.pop(context);
                      _scan(context, ref, ImageSource.gallery);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scan(
      BuildContext context, WidgetRef ref, ImageSource source) async {
    final result = await ref.read(ocrProvider.notifier).scanReport(source: source);

    if (!context.mounted) return;

    if (result == null) {
      _showSnackbar(context, '❌ স্ক্যান বাতিল হয়েছে', isError: true);
      return;
    }

    if (!result.hasAnyData) {
      _showSnackbar(context, '⚠️ কোনো তথ্য খুঁজে পাওয়া যায়নি', isError: true);
      return;
    }

    // Auto-fill callback
    onResultParsed(result);

    // Show what was extracted
    _showExtractedSheet(context, result);
  }

  void _showExtractedSheet(BuildContext context, OcrParsedResult result) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (_, controller) => Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.green.shade400, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'স্বয়ংক্রিয়ভাবে পূরণ হয়েছে',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (result.systolicBP != null || result.diastolicBP != null)
                _ExtractedItem(
                  icon: Icons.favorite_rounded,
                  label: 'রক্তচাপ',
                  value:
                      '${result.systolicBP ?? "-"}/${result.diastolicBP ?? "-"} mmHg',
                  color: Colors.red.shade400,
                ),
              if (result.cholesterol != null)
                _ExtractedItem(
                  icon: Icons.science_rounded,
                  label: 'কোলেস্টেরল',
                  value: '${result.cholesterol} mg/dL',
                  color: Colors.orange.shade400,
                ),
              if (result.heartRate != null)
                _ExtractedItem(
                  icon: Icons.monitor_heart_rounded,
                  label: 'হার্ট রেট',
                  value: '${result.heartRate} bpm',
                  color: Colors.pink.shade400,
                ),
              if (result.age != null)
                _ExtractedItem(
                  icon: Icons.person_rounded,
                  label: 'বয়স',
                  value: '${result.age} বছর',
                  color: Colors.blue.shade400,
                ),
              if (result.weight != null)
                _ExtractedItem(
                  icon: Icons.monitor_weight_rounded,
                  label: 'ওজন',
                  value: '${result.weight} kg',
                  color: Colors.purple.shade400,
                ),
              if (result.hasDiabetes)
                _ExtractedItem(
                  icon: Icons.bloodtype_rounded,
                  label: 'ডায়াবেটিস',
                  value: 'উল্লেখ আছে ✓',
                  color: Colors.amber.shade600,
                ),
              if (result.hasSmoking)
                _ExtractedItem(
                  icon: Icons.smoking_rooms_rounded,
                  label: 'ধূমপান',
                  value: 'উল্লেখ আছে ✓',
                  color: Colors.grey.shade600,
                ),
              const SizedBox(height: 16),
              Text(
                '* ফর্মে স্বয়ংক্রিয়ভাবে পূরণ করা হয়েছে। প্রয়োজনে যাচাই করুন।',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context),
                child: const Text('ঠিক আছে'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6))),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtractedItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ExtractedItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6))),
              Text(value,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          Icon(Icons.check_circle_outline_rounded,
              color: Colors.green.shade400, size: 20),
        ],
      ),
    );
  }
}
