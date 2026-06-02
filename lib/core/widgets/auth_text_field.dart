import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLarge.copyWith(
        color: Colors.white,
      ), // Chữ nhập vào màu trắng sáng
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
        prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary),

        // 1. Sử dụng cardColor (Xanh đen đậm) hoặc màu xám tối để ô nhập nổi bật trên nền đen
        filled: true,
        fillColor: AppColors.cardColor,

        // 2. Bo góc tròn cho ô nhập liệu
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        // 3. Viền mờ bao quanh ở trạng thái bình thường (tạo chiều sâu)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),

        // 4. Viền màu Vàng nổi bật khi người dùng nhấn vào nhập liệu (Focus)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.secondary, // Viền màu vàng
            width: 1.5,
          ),
        ),

        // 5. Viền màu Đỏ khi xảy ra lỗi nhập dữ liệu (Validator)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
      ),
    );
  }
}
