import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border? border;

  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.white,
    this.elevation = 2.0,
    this.borderRadius = AppRadius.lg,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin = EdgeInsets.zero,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primaryLight.withOpacity(0.1),
          highlightColor: AppColors.primaryLight.withOpacity(0.05),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.08),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ],
              border: border,
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final List<Color> colors;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const GradientCard({
    Key? key,
    required this.child,
    required this.colors,
    this.onTap,
    this.elevation = 3.0,
    this.borderRadius = AppRadius.lg,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.12),
                  blurRadius: elevation * 2.5,
                  offset: Offset(0, elevation),
                ),
              ],
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
