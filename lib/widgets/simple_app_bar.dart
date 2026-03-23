import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  const SimpleAppBar({super.key, required this.title, this.actions, this.leading});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontFamily: 'Changa')),
      centerTitle: true,
      backgroundColor: AppTheme.goldColor,
      foregroundColor: Colors.black,
      leading: leading,
      actions: actions,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
