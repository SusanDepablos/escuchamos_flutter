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

  // Variable para controlar la visibilidad del input
  bool _showInput = false; 
  TextEditingController _textController = TextEditingController();

  final filters = {
    'pag': '10',
    'page': null,
    'user_id': null
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        // Ocultar el input si el scroll se mueve
        if (_showInput &&
            _scrollController.position.isScrollingNotifier.value) {
          setState(() {
            _showInput = false; // Oculta el TextField
          });
        }

        // Cargar más posts si se llega al final
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
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
    } finally {
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
      var response = await ReactionCommandPost(ReactionPost()).execute('post', id);

      if (response is SuccessResponse) {
        setState(() {
          bool hasReaction = reactionStates[index];
          reactionStates[index] = !hasReaction;

          if (reactionStates[index]) {
            posts[index].relationships.reactionsCount += 1;
          } else {
            posts[index].relationships.reactionsCount = max(0, posts[index].relationships.reactionsCount - 1);
          }
        });
      } else {
        await showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is InternalServerError ? 'Error' : 'Error de Conexión',
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
    _textController.dispose(); // Destruir el controlador de texto
    super.dispose();
  }

  void _toggleInputVisibility() {
    setState(() {
      _showInput = !_showInput;
    });
    if (_showInput) {
      FocusScope.of(context).requestFocus(FocusNode()); // Cierra el teclado
    }
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
          : GestureDetector(
              onTap: () {
                if (_showInput) {
                  _toggleInputVisibility(); // Cierra el input al tocar fuera
                }
              },
              child: Center(
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
                                  final bool hasReaction = reactionStates[index];
                                  return PostWidget(
                                    reaction: hasReaction,
                                    onLikeTap: () => _postReaction(index, post.id),
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
                                      );
                                    },

                                    onCommentTap: () {
                                      setState(() {
                                        _showInput =
                                            true; // Muestra el TextField al tocar el comentario
                                      });
                                    },

                                    body: post.attributes.body,
                                    mediaUrls: mediaUrls,
                                    createdAt: post.attributes.createdAt,
                                    reactionsCount: post.relationships.reactionsCount.toString(),
                                    commentsCount: post.relationships.commentsCount.toString(),
                                    sharesCount: post.relationships.sharesCount.toString(),
                                  );
                                },
                              ),
                            ),
                    ),
                    if (_showInput) // Muestra el input solo si _showInput es verdadero
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  hintText: 'Escribe un comentario...',
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () {
                                  setState(() {
                                    _showInput = true; // Muestra el input al tap
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                // Lógica para enviar el comentario...
                                _textController.clear();
                                _toggleInputVisibility(); // Cierra el input después de enviar
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
