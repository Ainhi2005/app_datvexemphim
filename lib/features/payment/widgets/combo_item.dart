// lib/features/booking/widgets/combo_item.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/combo_model.dart';

class ComboItem extends StatelessWidget {
  final ComboModel combo;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ComboItem({super.key, required this.combo, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Nền trắng chứa icon
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.fastfood, color: Colors.black54, size: 30),
          ),
          const SizedBox(width: 16),
          // Thông tin Combo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(combo.name, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(combo.description, style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
                const SizedBox(height: 6),
                Text("${combo.price.toInt()}đ", style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Cụm nút +/- tròn màu vàng
          Row(
            children: [
              _buildRoundButton(Icons.remove, onRemove),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("${combo.quantity}", style: AppTextStyles.titleMedium.copyWith(color: AppColors.secondary)),
              ),
              _buildRoundButton(Icons.add, onAdd),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 24, height: 24,
        decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }
}