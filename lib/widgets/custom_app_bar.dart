import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  const CustomAppBar({super.key, required this.title, this.actions, this.leading, this.centerTitle = true, this.elevation = 0});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: Text(title, style: const TextStyle(fontFamily: 'Changa', fontWeight: FontWeight.bold)),
      centerTitle: centerTitle,
      backgroundColor: isDark ? AppTheme.darkCard : AppTheme.goldColor,
      foregroundColor: isDark ? AppTheme.goldColor : Colors.black,
      elevation: elevation,
      leading: leading,
      actions: actions,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
