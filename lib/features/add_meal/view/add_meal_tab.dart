import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../controller/add_meal_controller.dart';

class AddMealTab extends StatefulWidget {
  const AddMealTab({super.key});

  @override
  State<AddMealTab> createState() => _AddMealTabState();
}

class _AddMealTabState extends State<AddMealTab>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _minutesController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _servingsController = TextEditingController(text: '1');
  String _selectedCategory = 'Italian';
  String _selectedDifficulty = 'متوسط';

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  static const _categories = [
    'Italian',
    'Chicken',
    'Dessert',
    'Egyptian',
    'Indian',
    'Mexican',
    'Japanese',
    'American',
    'Healthy',
    'Other',
  ];

  static const _difficulties = ['سهل', 'متوسط', 'صعب'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _minutesController.dispose();
    _caloriesController.dispose();
    _servingsController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<AddMealController>();
    final success = await controller.addMeal(
      name: _nameController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      ingredients: _ingredientsController.text,
      instructions: _instructionsController.text,
      minutes: int.parse(_minutesController.text),
      calories: int.parse(_caloriesController.text),
      servings: int.parse(_servingsController.text),
      difficulty: _selectedDifficulty,
    );

    if (!mounted) return;
    if (success) {
      _formKey.currentState!.reset();
      _nameController.clear();
      _descriptionController.clear();
      _ingredientsController.clear();
      _instructionsController.clear();
      _minutesController.clear();
      _caloriesController.clear();
      _servingsController.text = '1';
      setState(() {
        _selectedCategory = 'Italian';
        _selectedDifficulty = 'متوسط';
      });
      _animController.forward(from: 0);
      if (mounted) {
        AppToast.show(context, 'تم حفظ الأكلة بنجاح في Firebase');
      }
    } else {
      AppToast.show(context, controller.errorMessage ?? 'حدث خطأ',
          isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddMealController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة أكلة'),
        actions: [
          ScaleTransition(
            scale: _scaleAnim,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(Icons.check_circle,
                  color: AppColors.success, size: 28),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
            children: [
              _buildHeaderCard(theme),
              const SizedBox(height: 24),
              _buildSectionTitle(theme, 'معلومات الأكلة', Icons.info_outline),
              const SizedBox(height: 12),
              AppTextField(
                controller: _nameController,
                hint: 'مثال: مكرونة بالصلصة',
                label: 'اسم الأكلة',
                icon: Icons.restaurant_menu_rounded,
                textInputAction: TextInputAction.next,
                validator: (v) => _required(v, 'أدخل اسم الأكلة'),
              ),
              const SizedBox(height: 14),
              _buildCategoryDropdown(theme),
              const SizedBox(height: 14),
              _buildDifficultySelector(theme),
              const SizedBox(height: 14),
              _buildInfoRow(theme),
              const SizedBox(height: 24),
              _buildSectionTitle(theme, 'الوصفة', Icons.menu_book_outlined),
              const SizedBox(height: 12),
              _MultilineField(
                controller: _descriptionController,
                label: 'وصف مختصر',
                hint: 'اكتب وصفا بسيطا للأكلة',
                icon: Icons.notes_rounded,
                validator: (v) => _required(v, 'أدخل وصفا مختصرا'),
              ),
              const SizedBox(height: 14),
              _MultilineField(
                controller: _ingredientsController,
                label: 'المكونات',
                hint: 'كل مكون في سطر منفصل',
                icon: Icons.list_alt_rounded,
                minLines: 4,
                validator: (v) => _required(v, 'أدخل المكونات'),
              ),
              const SizedBox(height: 14),
              _MultilineField(
                controller: _instructionsController,
                label: 'طريقة التحضير',
                hint: 'اكتب خطوات التحضير',
                icon: Icons.format_list_numbered_rounded,
                minLines: 5,
                validator: (v) => _required(v, 'أدخل طريقة التحضير'),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'حفظ الأكلة',
                icon: Icons.cloud_upload_rounded,
                isLoading: controller.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.20 : 0.05,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.restaurant_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سجل وصفتك الخاصة',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'املأ البيانات وسيتم حفظ الأكلة في Cloud Firestore.',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.55),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('التصنيف',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor,
              width: 1.1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary),
              items: _categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('مستوى الصعوبة',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: _difficulties.map((d) {
            final isSelected = _selectedDifficulty == d;
            final color = d == 'سهل'
                ? AppColors.success
                : d == 'متوسط'
                    ? AppColors.warning
                    : AppColors.error;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDifficulty = d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : theme.inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? color : theme.dividerColor,
                        width: isSelected ? 1.8 : 1.1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSelected)
                          Icon(Icons.check_circle_rounded,
                              size: 16, color: color),
                        if (isSelected) const SizedBox(width: 4),
                        Text(
                          d,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? color
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: _minutesController,
            hint: '30',
            label: 'الوقت (دقيقة)',
            icon: Icons.timer_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (v) => _positiveNumber(v, 'أدخل وقتا صحيحا'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppTextField(
            controller: _caloriesController,
            hint: '450',
            label: 'السعرات',
            icon: Icons.local_fire_department_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (v) => _positiveNumber(v, 'أدخل سعرات صحيحة'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppTextField(
            controller: _servingsController,
            hint: '1',
            label: 'عدد الأشخاص',
            icon: Icons.people_outline_rounded,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (v) => _positiveNumber(v, 'أدخل عددا صحيحا'),
          ),
        ),
      ],
    );
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  String? _positiveNumber(String? value, String message) {
    final number = int.tryParse(value ?? '');
    if (number == null || number <= 0) return message;
    return null;
  }
}

class _MultilineField extends StatelessWidget {
  const _MultilineField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.minLines = 3,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?) validator;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: minLines + 2,
          validator: validator,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Icon(icon, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
