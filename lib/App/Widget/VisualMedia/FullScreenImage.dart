import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

 
  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: imageUrl,
              child: Image.network(imageUrl),
            ),
          ),
          Positioned(
            child: SafeArea(
              child: IconButton(
                icon: const Icon(MaterialIcons.back, color: Colors.white, size: 25.0),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
