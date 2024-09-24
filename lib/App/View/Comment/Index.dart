import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Model/CommentModels.dart';
import 'package:escuchamos_flutter/Api/Command/CommentCommand.dart';
import 'package:escuchamos_flutter/Api/Service/CommentService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Comment/CommentListView.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/CustomRefreshIndicator.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Command/ReactionCommand.dart';
import 'package:escuchamos_flutter/Api/Service/ReactionService.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();
class IndexComment extends StatefulWidget {
  final String? postId;
  final String? commentId;
  IndexComment({this.postId, this.commentId});
  @override
  _IndexCommentState createState() => _IndexCommentState();
}

class _IndexCommentState extends State<IndexComment> {
  List<Datum> comments = [];
  List<bool> reactionStates = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  bool? reaction;
  int page = 1;
  int? _id;

//modificar
  final filters = {
    'pag': '10',
    'page': null,
    'post_id': null,
    'comment_id': null
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchComments();
          }
        }
      });
    _getData();
    fetchComments();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });
  }

  Future<void> fetchComments() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    if (widget.commentId != null) {
      filters['comment_id'] = widget.commentId;
    }

    filters['post_id'] = widget.postId?.toString();
    filters['page'] = page.toString();

    final commentCommand = CommentCommandIndex(CommentIndex(), filters);

    try {
      var response = await commentCommand.execute();

      if (response is CommentsModel) {
        setState(() {
          if (widget.commentId == null) {
            comments.addAll(response.results.data
                .where((comment) => comment.attributes.commentId == null));
          } else {
            comments.addAll(response.results.data);
          }

          _hasMorePages = response.next != null && response.next!.isNotEmpty;
          page++;
        });

        reactionStates.addAll(
          response.results.data
              .map((comment) => comment.relationships.reactions.any(
                    (reaction) => reaction.attributes.userId == _id,
                  )),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title:
            response is InternalServerError ? 'Error' : 'Error de Conexión',
            message: response.message,
          ),
        );
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error de Flutter',
          message: 'Espera un poco, pronto lo solucionaremos.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initialLoading =
              false; // Después de la primera carga, ya no mostrar la pantalla de carga
        });
      }
    }
  }

  Future<void> _reloadPosts() async {
    setState(() {
      page = 1;
      comments.clear();
      _hasMorePages = true;
      _initialLoading = true; // Vuelve a activar el estado de carga inicial
    });
    await fetchComments(); // Llama a fetchPosts para recargar los datos
    setState(() {
      _initialLoading = false; // Desactiva el estado de carga después de recargar los posts
    });
  }

  Future<void> _postReaction(int index, int id) async {
    try {
      var response = await ReactionCommandPost(ReactionPost()).execute( 
        'comment', id
      );

      if (response is SuccessResponse) {
        setState(() {
          // Cambia el estado de la reacción en la lista
          bool hasReaction = reactionStates[index];
          reactionStates[index] = !hasReaction;

          // Modifica el reactionsCount dependiendo del estado de la reacción
          if (reactionStates[index]) {
            // Si se coloca en rojo (se agrega reacción), sumarle 1
            comments[index].relationships.reactionsCount += 1;
          } else {
            // Si se coloca en gris (se quita reacción), restarle 1
            comments[index].relationships.reactionsCount -= 1;
          }
        });
        // await showDialog(
        //   context: context,
        //   builder: (context) => PopupWindow(
        //     title: 'Éxito',
        //     message: response.message,
        //   ),
        // );
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Visibility(
          visible: widget.commentId == null,
          child: AppBar(
            backgroundColor: AppColors.whiteapp,
            centerTitle: true,
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Comentarios',
                    style: TextStyle(
                      fontSize: AppFond.title,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: _initialLoading
          ? const LoadingScreen(
              animationPath: 'assets/animation.json',
              verticalOffset: -0.3, // Mueve la animación hacia arriba
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: comments.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay comentarios.',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        )
                      : CustomRefreshIndicator(
                      onRefresh: _reloadPosts,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final bool hasReaction = reactionStates[index];
                          return CommentWidget(
                            reaction: hasReaction,
                            onLikeTap: () => _postReaction(index, comment.id), // Pasa el índice y el ID del post,
                            nameUser: comment.relationships.user.name,
                            usernameUser: comment.relationships.user.username,
                            profilePhotoUser: comment.relationships.user.profilePhotoUrl ?? '',
                            onProfileTap: () {
                              final userId = comment.relationships.user.id;
                              Navigator.pushNamed(
                                context,
                                'profile',
                                arguments: userId,
                              );
                            },
                            onResponseTap: () {
                              final commentId = comment.id;
                              Navigator.pushNamed(
                                context,
                                'nested-comments',
                                arguments: commentId,
                              );
                            },
                            body: comment.attributes.body,
                            mediaUrl: comment.relationships.file.firstOrNull?.attributes.url,
                            createdAt: comment.attributes.createdAt,
                            reactionsCount: comment.relationships.reactionsCount.toString(),
                            repliesCount: comment.relationships.repliesCount.toString(),
                          );
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
