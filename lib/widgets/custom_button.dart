import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  const CustomButton({super.key, required this.text, required this.onPressed, this.isOutlined = false, this.isLoading = false, this.icon, this.backgroundColor, this.textColor});
  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppTheme.goldColor,
            side: const BorderSide(color: AppTheme.goldColor, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppTheme.goldColor,
            foregroundColor: textColor ?? Colors.black,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          );
    final child = isLoading
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
              Text(text, style: const TextStyle(fontFamily: 'Changa', fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          );
    return isOutlined
        ? OutlinedButton(onPressed: isLoading ? null : onPressed, style: buttonStyle, child: child)
        : ElevatedButton(onPressed: isLoading ? null : onPressed, style: buttonStyle, child: child);
  }
}
