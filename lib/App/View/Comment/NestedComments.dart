import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Comment/CommentListView.dart';
import 'package:escuchamos_flutter/Api/Model/CommentModels.dart';
import 'package:escuchamos_flutter/Api/Command/CommentCommand.dart';
import 'package:escuchamos_flutter/Api/Service/CommentService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Command/ReactionCommand.dart';
import 'package:escuchamos_flutter/Api/Service/ReactionService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
FlutterSecureStorage _storage = FlutterSecureStorage();

class NestedComments extends StatefulWidget {
  int commentId;

  NestedComments({required this.commentId});

  @override
  _NestedCommentsState createState() => _NestedCommentsState();
}

class _NestedCommentsState extends State<NestedComments> {
  CommentModel? _comment;
  String? _name;
  String? _username;
  String? _profilePhotoUrl;
  String? _body;
  String? _mediaUrl;
  String? _reactionsCount;
  List<bool> reactionStates = [false]; 

  Future<void> _callComment() async {
    final commentCommand = CommentCommandShow(CommentShow(), widget.commentId);
    try {
      final response = await commentCommand.execute();

      if (mounted) {
        if (response is CommentModel) {
          setState(() {
            _comment = response;
            _name = _comment!.data.relationships.user.name;
            _username = _comment!.data.relationships.user.username;
            _profilePhotoUrl =
                _comment?.data.relationships.user.profilePhotoUrl;
            _body = _comment?.data.attributes.body;
            _mediaUrl =
                _comment?.data.relationships.file.firstOrNull?.attributes.url;
            _reactionsCount =
                _comment?.data.relationships.reactionsCount.toString();
            // Obtener el ID del usuario de manera asíncrona
            _setReactionState();
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => PopupWindow(
              title: response is InternalServerError
                  ? 'Error'
                  : 'Error de Conexión',
              message: response.message,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    }
  }

  Future<void> _setReactionState() async {
    final userId = await _storage.read(key: 'user') ?? '0';
    setState(() {
      reactionStates[0] = _comment!.data.relationships.reactions
          .any((reaction) => reaction.attributes.userId == int.parse(userId));
    });
  }

  Future<void> _commentReaction(int index, int id) async {
    try {
      var response =
          await ReactionCommandPost(ReactionPost()).execute('comment', id);

      if (response is SuccessResponse) {
        setState(() {
          // Cambia el estado de la reacción
          bool hasReaction = reactionStates[index];
          reactionStates[index] = !hasReaction;

          // Modifica el reactionsCount dependiendo del estado de la reacción
          if (reactionStates[index]) {
            // Si se agrega reacción, sumar 1
            _comment!.data.relationships.reactionsCount += 1;
          } else {
            // Si se quita reacción, restar 1
            _comment!.data.relationships.reactionsCount -= 1;
          }
        });
      } else {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title:
                response is InternalServerError ? 'Error' : 'Error de Conexión',
            message: response.message,
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: e.toString(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _callComment(); // Cargar el comentario al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Comentarios',
                style: TextStyle(
                  fontSize: AppFond.title,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ),
            if (_comment != null) // Verifica si el comentario está disponible
              Container(
                height: 100, // Altura del contenedor para el comentario
                child: CommentWidget(
                  reaction: reactionStates[0],
                  onLikeTap: () => _commentReaction(
                      0, _comment!.data.id), // Usa el ID del comentario cargado
                  nameUser: _name.toString(),
                  usernameUser: _username.toString(),
                  profilePhotoUser: _profilePhotoUrl ?? '',
                  onProfileTap: () {
                    final userId = _comment!.data.relationships.user.id;
                    Navigator.pushNamed(context, 'profile', arguments: userId);
                  },
                  body: _body,
                  mediaUrl: _mediaUrl,
                  createdAt: _comment!.data.attributes.createdAt,
                  reactionsCount: _reactionsCount.toString(),
                ),
              ),
          ],
        ),
      ),
      body: _comment == null
          ? const LoadingScreen(
              animationPath: 'assets/animation.json', verticalOffset: -0.3)
          : Container(), // Aquí puedes agregar más contenido si es necesario
    );
  }
}
