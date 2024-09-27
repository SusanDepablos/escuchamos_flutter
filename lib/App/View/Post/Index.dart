import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Model/PostModels.dart';
import 'package:escuchamos_flutter/Api/Command/PostCommand.dart';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/PostListView.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/CustomRefreshIndicator.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Command/ReactionCommand.dart';
import 'package:escuchamos_flutter/Api/Service/ReactionService.dart';
import 'dart:math';

final FlutterSecureStorage _storage = FlutterSecureStorage();
int postId_ = 0 ;
bool? likeState;
class IndexPost extends StatefulWidget {
  final int? userId;
  IndexPost({this.userId});
  @override
  _IndexPostState createState() => _IndexPostState();
}

class _IndexPostState extends State<IndexPost> {
  List<Datum> posts = [];
  List<bool> reactionStates = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  bool? reaction;
  int page = 1;
  int? _id;
  PostModel? _post;


  final filters = {
    'pag': '10',
    'page': null,
    'user_id': null
  };

  final input = {
    'body': TextEditingController(),
  
  };

  final _borderColors = {
    'body': AppColors.inputLigth,
  };

  final Map<String, String?> _errorMessages = {
    'body': null,
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchPosts();
          }
        }
      });
    _getData();
    fetchPosts();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });
  }

  Future<void> fetchPosts() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    if (widget.userId != null) {
      filters['user_id'] = widget.userId?.toString();
    }

    filters['page'] = page.toString();

    final postCommand = PostCommandIndex(PostIndex(), filters);

    try {
      var response = await postCommand.execute();

      if (response is PostsModel) {
        setState(() {
          posts.addAll(response.results.data);
          _hasMorePages = response.next != null && response.next!.isNotEmpty;
          page++;
          
          reactionStates.addAll(
            response.results.data.map((post) => post.relationships.reactions.any(
              (reaction) => reaction.attributes.userId == _id,
            )),
          );
          
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is InternalServerError ? 'Error de servidor' : 'Error de conexión',
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
      }
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initialLoading = false;
        });
      }
    }
  }

  Future<void> _reloadPosts() async {
    setState(() {
      page = 1;
      posts.clear();
      _hasMorePages = true;
      _initialLoading = true;
    });
    await fetchPosts();
    setState(() {
      _initialLoading = false;
    });
  }

  Future<void> _postReaction(int index, int id) async {
      if (index < 0 || index >= posts.length) return;

      try {
        var response =  await ReactionCommandPost(ReactionPost()).execute('post', id);

        if (response is SuccessResponse) {
          setState(() {
            bool hasReaction = reactionStates[index];
            reactionStates[index] = !hasReaction;

            if (reactionStates[index]) {
              posts[index].relationships.reactionsCount += 1;
            } else {
              posts[index].relationships.reactionsCount =
                  max(0, posts[index].relationships.reactionsCount - 1);
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

  Future<void> _callPost() async {
    try {
      final postCommand = PostCommandShow(PostShow(), postId_);
      
      final response = await postCommand.execute();

      if (mounted) {
        if (response is PostModel) {
          if (postId_ != 0) {
            setState(() {
              _post = response;

              int postIndex = posts.indexWhere((post) => post.id == postId_);
              if (postIndex >= 0 && postIndex < posts.length) {
                posts[postIndex].relationships.reactionsCount =
                    _post!.data.relationships.reactionsCount;

                posts[postIndex].relationships.commentsCount =
                    _post!.data.relationships.commentsCount;

                posts[postIndex].relationships.commentsCount =
                    _post!.data.relationships.commentsCount;

                if (likeState != null) {
                  reactionStates[postIndex] = likeState!;
                }
              }
            });
          }
        } else {
          await showDialog(
            context: context,
            builder: (context) => AutoClosePopupFail(
              child: const FailAnimationWidget(), // Aquí se pasa la animación
              message: response.message,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        print(e);
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          postId_ = 0;
        });
      }
    }
  }

  void _showTextAreaDialog(BuildContext context, String? body, int postId) {
    postId_ = postId;  // Establecer el ID de la publicación

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateLocal) {  // `setState` local del diálogo
            return AlertDialog(
              title: const Text('Editar Publicación'),
              backgroundColor: AppColors.whiteapp,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextArea(
                      input: input['body']!,
                      border: _borderColors['body']!,
                      error: _errorMessages['body'],
                      minLines: 6,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.black),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _updatePost(
                      input['body']!.text, 
                      postId_,
                      setStateLocal,  // `setState` local
                      context,
                    );
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: AppColors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updatePost(String body, int postId, 
    Function setStateLocal,  // `setState` local del diálogo
    BuildContext context  // Contexto para el `setState` global
  ) async {
    try {
      var response = await PostCommandUpdate(PostUpdate()).execute(body, postId);

      if (response is ValidationResponse) {
        if (response.key['body'] != null) {
          // Actualiza el estado local para los errores de validación
          setStateLocal(() {
            _borderColors['body'] = AppColors.inputLigth;
            _errorMessages['body'] = response.message('body');
          });
          Future.delayed(const Duration(seconds: 2), () {
            setStateLocal(() {
              _borderColors['body'] = AppColors.inputLigth;
              _errorMessages['body'] = null;
            });
          });
        }
      } else if (response is SuccessResponse) {
        // Usar `setState` global para actualizar la lista de publicaciones
        setState(() {
          int postIndex = posts.indexWhere((post) => post.id == postId);
          if (postIndex != -1) {
            posts[postIndex].attributes.body = body;
          }
        });
        Navigator.of(context).pop(); // Cerrar el diálogo
        showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(),
            message: response.message,
          ),
        );
      } else {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(),
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


  Future<void> _deletePost(int id) async {
    try {
      var response = await DeleteCommandPost(DeletePost()).execute(id: id);

      if (response is SuccessResponse) {
        // Buscar el índice de la publicación que estás eliminando
        int postIndex = posts.indexWhere((post) => post.id == id);

        if (postIndex != -1) {
          // Eliminar la publicación de la lista
          setState(() {
            posts.removeAt(postIndex);
          });
          // Mostrar el diálogo con el mensaje de éxito
          await showDialog(
            context: context,
            builder: (context) => AutoClosePopup(
              child: const SuccessAnimationWidget(), // Aquí se pasa la animación
              message: response.message,
            ),
          );
        }
      } else {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopupFail(
            child: const FailAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
      }
    } catch (e) {
      // Manejar errores inesperados
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: 'Espera un poco, pronto lo solucionaremos.',
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
      body: _initialLoading
        ? const LoadingScreen(
            animationPath: 'assets/animation.json',
            verticalOffset: -0.3,
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: posts.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay publicaciones.',
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
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final mediaUrls = post.relationships.files.map((file) => file.attributes.url).toList();
                            final bool hasReaction = reactionStates[index]; // Usa el estado de la lista
                            return PostWidget(
                              reaction: hasReaction,
                              onLikeTap: () => _postReaction(index, post.id), // Pasa el índice y el ID del post,
                              nameUser: post.relationships.user.name,
                              usernameUser: post.relationships.user.username,
                              profilePhotoUser: post.relationships.user.profilePhotoUrl ?? '',
                              onProfileTap: () {
                                final userId = post.relationships.user.id;
                                Navigator.pushNamed(
                                  context,
                                  'profile',
                                  arguments: userId,
                                );
                              },
                              onIndexLikeTap: () {
                                String objectId = post.id.toString();
                                Navigator.pushNamed(
                                  context,
                                  'index-reactions',
                                  arguments: {
                                    'objectId': objectId,
                                    'model': 'post',
                                    'appBar': 'Reacciones'
                                  },
                                );
                              },
                                onIndexCommentTap: () {
                                  String postId = post.id.toString();
                                  Navigator.pushNamed(
                                    context,
                                    'index-comments',
                                    arguments: {
                                      'postId': postId,
                                    },
                                  ).then((_) {
                                    // Esto se ejecuta cuando regresas de 'index-comments'
                                    _callPost();
                                  });
                                },

                              body: post.attributes.body,
                              mediaUrls: mediaUrls,
                              createdAt: post.attributes.createdAt,
                              reactionsCount: post.relationships.reactionsCount.toString(),
                              commentsCount: post.relationships.commentsCount.toString(),
                              sharesCount: post.relationships.sharesCount.toString(),
                              authorId: post.relationships.user.id, 
                              currentUserId: _id!,
                              onDeleteTap: () {
                                _deletePost(post.id); 
                              },
                              onEditTap: () { // Llama a la función de edición
                                input['body']!.text = post.attributes.body ?? ''; // Asegurarte de que no sea nulo
                                // Llamar al cuadro de diálogo para editar la publicación
                                _showTextAreaDialog(context, input['body']!.text, post.id);
                              },
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
