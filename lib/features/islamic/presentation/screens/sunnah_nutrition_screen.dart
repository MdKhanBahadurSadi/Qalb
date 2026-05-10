import 'package:flutter/material.dart';
import '../../data/datasources/sunnah_food_datasource.dart';
import '../../domain/entities/sunnah_food.dart';

class SunnahNutritionScreen extends StatelessWidget {
  const SunnahNutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foods = SunnahFoodDataSource.getSunnahFoods();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('সুন্নাহ পুষ্টি')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return _FoodCard(food: food);
        },
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final SunnahFood food;
  const _FoodCard({required this.food});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: InkWell(
        onTap: () => _showDetail(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(food.emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(
                food.nameBangla,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                food.heartBenefits[0],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant, 
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.nameArabic, 
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold, 
                            fontFamily: 'Noto Naskh Arabic',
                          ),
                        ),
                        Text(
                          food.nameBangla, 
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(food.emoji, style: const TextStyle(fontSize: 48)),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(context, 'হাদিস', food.hadithBangla, icon: Icons.menu_book, isHadith: true, source: food.hadithSource),
              const SizedBox(height: 20),
              _buildBenefitList(context, 'হার্টের উপকারিতা', food.heartBenefits),
              const SizedBox(height: 20),
              _buildSection(context, 'ব্যবহারবিধি', food.howToConsume, icon: Icons.restaurant),
              const SizedBox(height: 20),
              _buildSection(context, 'বৈজ্ঞানিক ব্যাখ্যা', food.scientificBasis, icon: Icons.science),
              if (food.caution != null) ...[
                const SizedBox(height: 20),
                _buildSection(
                  context, 
                  'সতর্কতা', 
                  food.caution!, 
                  icon: Icons.warning, 
                  color: theme.colorScheme.error,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notifications_active),
                label: const Text('মনে করিয়ে দিন'),
                style: theme.elevatedButtonTheme.style,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, {IconData? icon, bool isHadith = false, String? source, Color? color}) {
    final theme = Theme.of(context);
    final sectionColor = color ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, size: 20, color: sectionColor),
            if (icon != null) const SizedBox(width: 8),
            Text(
              title, 
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold, 
                color: color ?? theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHadith 
                ? theme.colorScheme.primary.withValues(alpha: 0.05) 
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: isHadith ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  fontStyle: isHadith ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              if (source != null) ...[
                const SizedBox(height: 8),
                Text(
                  '— $source', 
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitList(BuildContext context, String title, List<String> benefits) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite, size: 20, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              title, 
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...benefits.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      b, 
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
