import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;

  CustomLoadingIndicator({this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
