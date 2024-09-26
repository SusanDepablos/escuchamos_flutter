import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // Función para restablecer el zoom
  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity(); // Restablecer zoom
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: GestureDetector(
        onDoubleTap: _handleDoubleTap, // Doble clic para restablecer zoom
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: widget.imageUrl,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Image.network(widget.imageUrl),
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              left: 10.0,
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
      ),
    );
  }
}
