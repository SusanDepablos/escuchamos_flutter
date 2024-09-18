import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart'; // Asegúrate de que los colores estén definidos en este archivo
import 'package:escuchamos_flutter/App/View/Post/NavigatorPost.dart';

class NewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigatorPost(
      initialTab: 'posts', // Establece la pestaña inicial según lo que desees
    );
  }
}