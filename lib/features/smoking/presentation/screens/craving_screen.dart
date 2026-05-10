import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class CravingScreen extends StatelessWidget {
  const CravingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('ক্র্যাভিং মোকাবিলা')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.favorite, size: 80, color: Colors.redAccent),
            const SizedBox(height: 24),
            Text(
              'ধৈর্য ধরুন, আল্লাহ আপনার সাথে আছেন',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'ক্র্যাভিং সাধারণত ৩-৫ মিনিট স্থায়ী হয়। নিচের কাজগুলো করার চেষ্টা করুন:',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            _buildActionItem(
              context,
              icon: Icons.water_drop,
              title: 'এক গ্লাস পানি পান করুন',
              subtitle: 'আস্তে আস্তে চুমুক দিন',
              color: Colors.blue,
            ),
            _buildActionItem(
              context,
              icon: Icons.air,
              title: 'দীর্ঘ শ্বাস নিন',
              subtitle: '৫ বার গভীর শ্বাস নিয়ে ছাড়ুন',
              color: Colors.teal,
            ),
            _buildActionItem(
              context,
              icon: Icons.menu_book,
              title: 'জিকির করুন',
              subtitle: '১০ বার "লা হাওলা ওয়া লা কুয়াতা ইল্লা বিল্লাহ" পড়ুন',
              color: theme.colorScheme.primary,
            ),
            _buildActionItem(
              context,
              icon: Icons.directions_walk,
              title: 'একটু হাঁটুন',
              subtitle: 'জায়গা পরিবর্তন করলে মন অন্যদিকে যাবে',
              color: Colors.orange,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (await Vibration.hasVibrator() == true) {
                  Vibration.vibrate(duration: 100);
                }
                if (context.mounted) Navigator.pop(context);
              },
              style: theme.elevatedButtonTheme.style,
              child: const Text('আমি ভালো বোধ করছি, আলহামদুলিল্লাহ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle, 
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
}
