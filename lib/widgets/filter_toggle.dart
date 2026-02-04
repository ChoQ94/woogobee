import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FilterToggle extends StatelessWidget {
  final bool isSharedSelected;
  final ValueChanged<bool> onChanged;

  const FilterToggle({
    super.key,
    required this.isSharedSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            label: '개인',
            icon: Icons.person_outline,
            isSelected: !isSharedSelected,
            onTap: () => onChanged(false),
          ),
          _buildToggleButton(
            label: '공유',
            icon: Icons.people_outline,
            isSelected: isSharedSelected,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
