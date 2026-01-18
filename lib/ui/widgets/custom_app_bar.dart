

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/core/constants/app_assets.dart';
import 'package:taskmanager/core/constants/common_colors.dart';

import 'custom_image_viewer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? titleTextStyle;
  final bool centerTitle;
  final Widget? leading;
  final VoidCallback? onLeadingTap;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleTextStyle,
    this.centerTitle = true,
    this.leading,
    this.onLeadingTap,
    this.actions,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: elevation,
      backgroundColor: backgroundColor ?? Colors.white,
      centerTitle: centerTitle,
      leadingWidth: 60,
      bottom: bottom,
      leading: leading ?? _buildDefaultLeading(context),
      title:
      title != null
          ? Text(
        title!,
        style:
        titleTextStyle ??
          TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black
          )
      )
          : null,
      actions: actions,
    );
  }

  Widget _buildDefaultLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onLeadingTap ?? () => Navigator.pop(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomImage(
              width: 7,
              height: 14,
              path: AppAssets.backArrow,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}