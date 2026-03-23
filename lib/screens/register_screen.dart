import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _userType = 'buyer';
  String _selectedCity = 'صنعاء';
  bool _isLoading = false;
  bool _agreeToTerms = false;

  final List<String> _cities = ['صنعاء', 'عدن', 'تعز', 'حضرموت', 'إب', 'الحديدة', 'المكلا', 'سيئون'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب الموافقة على الشروط والأحكام')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService.signUpWithEmail(_emailController.text.trim(), _passwordController.text);
        _emailController.text.trim(),
        _passwordController.text,
        data: {
          'full_name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'user_type': _userType,
          'city': _selectedCity,
        },
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الحساب بنجاح، يرجى تسجيل الدخول')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل إنشاء الحساب: $e', style: const TextStyle(fontFamily: 'Changa')),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.person_add, size: 40, color: Colors.black),
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 600)),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'الاسم الكامل',
                  controller: _nameController,
                  validator: (v) => v?.isEmpty == true ? 'الاسم مطلوب' : null,
                ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'البريد الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v?.isEmpty == true) return 'البريد مطلوب';
                    if (!v!.contains('@')) return 'بريد غير صالح';
                    return null;
                  },
                ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'رقم الهاتف',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v?.isEmpty == true ? 'رقم الهاتف مطلوب' : null,
                ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'كلمة المرور',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (v) => v?.length ?? 0 < 6 ? 'كلمة المرور 6 أحرف على الأقل' : null,
                ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'تأكيد كلمة المرور',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (v) => v != _passwordController.text ? 'كلمة المرور غير متطابقة' : null,
                ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: const InputDecoration(
                    labelText: 'المدينة',
                    border: OutlineInputBorder(),
                  ),
                  items: _cities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedCity = v!),
                ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                      activeColor: AppTheme.goldColor,
                    ),
                    Expanded(
                      child: Text(
                        'أوافق على الشروط والأحكام',
                        style: TextStyle(fontFamily: 'Changa', color: AppTheme.getTextColor(context)),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'إنشاء حساب',
                  onPressed: _register,
                  isLoading: _isLoading,
                ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(fontFamily: 'Changa', color: AppTheme.getSecondaryTextColor(context)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('تسجيل الدخول', style: TextStyle(color: AppTheme.goldColor, fontFamily: 'Changa')),
                    ),
                  ],
                ).animate().fadeIn(delay: const Duration(milliseconds: 900)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
