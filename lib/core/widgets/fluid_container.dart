import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FluidContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final bool showShadow;

  const FluidContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppTheme.surfaceDark) : null,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: border ?? Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        boxShadow: showShadow ? AppTheme.fluidShadows : null,
      ),
      child: child,
    );
  }
}
