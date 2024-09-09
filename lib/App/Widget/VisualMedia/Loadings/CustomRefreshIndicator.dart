import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  // Constructor
  const CustomRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primaryBlue, // Personaliza el color del indicador
      backgroundColor: AppColors.whiteapp, // Personaliza el fondo del indicador
      child: child,
    );
  }
}
