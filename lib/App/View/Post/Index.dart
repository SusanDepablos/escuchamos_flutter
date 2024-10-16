import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Command/ShareCommand.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/Api/Service/ShareService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/PostUpdatePopup.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/RepostListView.dart';
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
import 'package:escuchamos_flutter/Api/Model/UserModels.dart' as user_model;
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

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
  Map<int, bool> reactionStates = {};
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  bool? reaction;
  int page = 1;
  int? _id;
  PostModel? _post;
  bool _submitting = false;
  user_model.UserModel? _user;
  String? _username;
  String? _profilePhotoUser;


  final filters = {
    'pag': '10',
    'page': null,
    'user_id': null
  };

  final input = {
    'body': TextEditingController(),
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
    _getData()
        .then((_) => _callUser());
    fetchPosts();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });
  }

  Future<void> _reloadPosts() async {
    setState(() {
      page = 1;
      posts.clear();
      _hasMorePages = true;
      _initialLoading = true;
    });
    await fetchPosts();
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

          for (var post in response.results.data) {
            reactionStates[post.id] = post.relationships.reactions.any(
              (reaction) => reaction.attributes.userId == _id,
            );
          }
          
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

  Future<void> _callPost() async {
    try {
      final postCommand = PostCommandShow(PostShow(), postId_);
      final response = await postCommand.execute();

      if (mounted) {
        if (response is PostModel) {
          if (postId_ != 0) {
            setState(() {
              _post = response;
              String? body =_post!.data.attributes.body;
              int totalSharesCount =_post!.data.relationships.totalSharesCount;
              for (var post in posts) {
                if (post.attributes.postId == postId_ && post.relationships.post != null) {
                  post.relationships.post!.attributes.body = body;
                  post.relationships.post!.relationships.totalSharesCount = totalSharesCount;
              }
              // Encontrar el índice del post comparando con `post.id == postId_`
              int postIndex = posts.indexWhere((post) => post.id == postId_);
              if (postIndex >= 0 && postIndex < posts.length) {
                // Actualizar las relaciones de reacciones y comentarios
                posts[postIndex].relationships.reactionsCount =
                    _post!.data.relationships.reactionsCount;

                posts[postIndex].relationships.commentsCount =
                    _post!.data.relationships.commentsCount;

                posts[postIndex].attributes.body = 
                    _post!.data.attributes.body;

                posts[postIndex].relationships.totalSharesCount= 
                    _post!.data.relationships.totalSharesCount;
                }

                final bool userLikedPost = _post!.data.relationships.reactions
                  .any((reaction) => reaction.attributes.userId == _id);

                reactionStates[postId_] = userLikedPost;
              }
            });
          }
        } else {    
            setState(() {
            // Eliminar todos los posts que coincidan con cualquiera de las dos condiciones
            posts.removeWhere((post) => post.id == postId_ || post.attributes.postId == postId_);
          });
        //   await showDialog(
        //     context: context,
        //     builder: (context) => AutoClosePopupFail(
        //           child: const FailAnimationWidget(),
        //           message: response.message,
        //         ));
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: e.toString(),
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

  Future<void> _postReaction(int index, int id) async {
      if (index < 0 || index >= posts.length) return;

      try {
        var response =  await ReactionCommandPost(ReactionPost()).execute('post', id);
        postId_ = id;
        if (response is SuccessResponse) {
          await _callPost();
        } else {
          setState(() {
            reactionStates[id] = !reactionStates[id]!;
          });
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

  void _clearErrorMessages() {
    setState(() {
      _errorMessages['body'] = null; // Limpia el mensaje de error específico
    });
  }

  void showPostPopup(BuildContext context, String? body, int postId, mediaUrls, bool isVerified){
    // Limpia los mensajes de error antes de abrir el diálogo
    _clearErrorMessages();
    postId_ = postId;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateLocal) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: PopupPostWidget(
                isButtonDisabled: _submitting,
                username: _username!,
                profilePhotoUser: _profilePhotoUser,
                error: _errorMessages['body'],
                body: body!,
                mediaUrls: mediaUrls,
                isVerified: isVerified,
                onCancel: () {
                  _clearErrorMessages(); // Limpia los mensajes de error
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                onPostUpdate: (String body) async {
                await _updatePost(
                  body, // Cuerpo actualizado
                  postId,      // ID del post
                  setStateLocal, 
                  context,
                );
                }
                
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updatePost(String body, int postId, 
    Function setStateLocal,
    BuildContext context 
  ) async {
    try {
      var response = await PostCommandUpdate(PostUpdate()).execute(body, postId);

      if (response is ValidationResponse) {
        if (response.key['body'] != null) {
          setStateLocal(() {
            _errorMessages['body'] = response.message('body');
          });
          Future.delayed(const Duration(seconds: 2), () {
          setStateLocal(() {
            _errorMessages['body'] = null;
          });
          });
        }
      } else if (response is SuccessResponse) {
        setState(() {
          int postIndex = posts.indexWhere((post) => post.id == postId);
          if (postIndex != -1) {
            // Primer setState para actualizar el body del post
            posts[postIndex].attributes.body = body;
          }
        });
        // Segundo setState para actualizar el body de relationships.post
        setState(() {
          // Itera sobre todos los posts y actualiza el body donde se encuentre el postId.
          for (var post in posts) {
            if (post.attributes.postId == postId && post.relationships.post != null) {
              post.relationships.post!.attributes.body = body;
            }
          }
        });
        Navigator.of(context).pop();
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

  String? _getFileUrlByType(String type) {
    try {
      final file = _user?.data.relationships.files.firstWhere(
        (file) => file.attributes.type == type,
      );
      return file!.attributes.url;
    } catch (e) {
      return null;
    }
  }
  
  Future<void> _callUser() async {
    final userCommand = UserCommandShow(UserShow(), _id!);

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is  user_model.UserModel) {
          setState(() {
            _user = response;
          _username = _user!.data.attributes.username;

          _profilePhotoUser = _getFileUrlByType('profile');
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

  Future<void> _deletePost(int id) async {
    try {
      var response = await DeleteCommandPost(PostDelete()).execute(id: id);

      if (response is SuccessResponse) {
        setState(() {
            // Eliminar todos los posts que coincidan con cualquiera de las dos condiciones
            posts.removeWhere((post) => post.id == id || post.attributes.postId == id);
        });
        _callPost();
        await showDialog(
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

  void _showReportDialog(int postId, BuildContext context) {
    List<Map<String, dynamic>> observationData = [
      {'id': 1, 'name': 'Contenido inapropiado'},
      {'id': 2, 'name': 'Spam o auto-promoción'},
      {'id': 3, 'name': 'Desinformación'},
      {'id': 4, 'name': 'Violación de derechos de autor'},
      {'id': 5, 'name': 'Acoso o intimidación'},
      {'id': 6, 'name': 'Otro'},
    ];

    String? selectedObservation = observationData[0]['name']; // "Contenido inapropiado"
    bool _submitting = false; // Variable para manejar el estado de envío

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: 'Reportar Publicación',
              content: 'Por favor, selecciona la razón para reportar esta publicación:',
              selectWidget: SelectBasic(
                hintText: 'Observación',
                selectedValue: observationData.firstWhere((item) => item['name'] == selectedObservation)['id'],
                items: observationData,
                onChanged: (value) {
                  setState(() {
                    selectedObservation = observationData.firstWhere((item) => item['id'] == value)['name'];
                  });
                },
              ),
              onAccept: () async {
                if (selectedObservation != null && !_submitting) { // Asegúrate de que no esté en envío
                  setState(() {
                    _submitting = true; // Bloquear el botón
                  });
                  await _postReport(postId, selectedObservation!, context); // Enviar el name seleccionado
                  setState(() {
                    _submitting = false; // Desbloquear el botón después de la función
                  });
                  Navigator.of(context).pop(); // Cierra el diálogo
                }
              },
              acceptButtonEnabled: !_submitting, // Habilitar/deshabilitar el botón
            );
          },
        );
      },
    );
  }

  Future<void> _postReport(int postId, String observation, BuildContext context) async {
    try {
      var response = await ReportCommandPost(ReportPost()).execute('post', postId, observation);
      if (response is SuccessResponse) {
        await showDialog(
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

  Future<void> _postShare(int postId,  BuildContext context) async {
    try {
      var response =  await ShareCommandPost(SharePost()).execute(postId);
      postId_ = postId;
        if (response is SuccessResponse) {
        _callPost();
        await showDialog(
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
                            fontSize: AppFond.subtitle,
                            color: AppColors.black,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      )
                    : CustomRefreshIndicator(
                        onRefresh: _reloadPosts,
                        child: ListView.builder(
                        controller: _scrollController,
                        itemCount: posts.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == posts.length) {
                            return SizedBox(
                              height: 60.0,
                              child: Center(
                                child: CustomLoadingIndicator(
                                    color: AppColors.primaryBlue),
                              ),
                            );
                          }
                          final post = posts[index];
                          final mediaUrls = post.relationships.files.map((file) => file.attributes.url).toList();
                          final mediaUrlsRepost = post.relationships.post?.relationships.files.map((file) => file.attributes.url).toList();
                          final bool hasReaction = reactionStates[post.id]!;
                          final bool isVerified = post.relationships.user.groupId?.contains(1) == true ||
                              post.relationships.user.groupId?.contains(2) == true;
                          if (post.attributes.postId == null) {
                            // Si existe el postId, devolvemos el PostWidget
                            return PostWidget(
                              reaction: hasReaction,
                              onLikeTap: () => _postReaction(index, post.id),
                              usernameUser: post.relationships.user.username,
                              profilePhotoUser: post.relationships.user.profilePhotoUrl ?? '',
                              onProfileTap: () {
                                int userId = post.relationships.user.id;
                                // Solo ejecuta la navegación si `userId` es diferente a `_id`
                                if (widget.userId == null) {
                                  Navigator.pushNamed(
                                    context,
                                    'profile',
                                    arguments: {'showShares': false, 'userId': userId},
                                  ).then((_) {
                                    postId_ = post.id;
                                    _callPost();
                                  });
                                }
                              },
                              onIndexLikeTap: () {
                                int objectId = post.id;
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
                                int postId = post.id;
                                Navigator.pushNamed(
                                  context,
                                  'index-comments',
                                  arguments: {
                                    'postId': postId,
                                  },
                                ).then((_) {
                                  postId_ = post.id;
                                  _callPost();
                                });
                              },
                              body: post.attributes.body,
                              mediaUrls: mediaUrls,
                              createdAt: post.attributes.createdAt,
                              reactionsCount: post.relationships.reactionsCount,
                              commentsCount: post.relationships.commentsCount,
                              totalSharesCount: post.relationships.totalSharesCount,
                              authorId: post.relationships.user.id,
                              currentUserId: _id!,
                              onDeleteTap: () {
                                postId_ = post.id;
                                _deletePost(post.id);
                              },
                              onEditTap: () {
                                input['body']!.text = post.attributes.body ?? '';
                                showPostPopup(context, input['body']!.text, post.id, mediaUrls, isVerified);
                              },
                              onRepostTap: () { 
                              int postId = post.id;
                                Navigator.pushNamed(
                                  context,
                                  'new-repost',
                                  arguments: {
                                    'postId': postId,
                                  },
                                ).then((_) {
                                  _callPost();
                                });
                              },
                              onReportTap: () {
                                int postId = post.id;
                                _showReportDialog(postId, context);
                              },
                              onShareTap: () {
                                int postId = post.id;
                                _postShare(postId, context);
                              }, 
                              isVerified: isVerified,
                            );
                          } else {
                            return RepostWidget(
                              reaction: hasReaction,
                              onLikeTap: () => _postReaction(index, post.id),
                              usernameUser: post.relationships.user.username,
                              profilePhotoUser: post.relationships.user.profilePhotoUrl ?? '',
                              onProfileTap: () {
                                int userId = post.relationships.user.id;
                                  if (widget.userId == null) {
                                    Navigator.pushNamed(
                                      context,
                                      'profile',
                                      arguments: {'showShares': false, 'userId': userId},
                                    ).then((_) {
                                      postId_ = post.id;
                                      _callPost();
                                  });
                                }
                              },
                              onIndexLikeTap: () {
                                int objectId = post.id;
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
                                int postId = post.id;
                                Navigator.pushNamed(
                                  context,
                                  'index-comments',
                                  arguments: {
                                    'postId': postId,
                                  },
                                ).then((_) {
                                  postId_ = post.id;
                                  _callPost();
                                });
                              },
                              body: post.attributes.body,
                              createdAt: post.attributes.createdAt,
                              reactionsCount: post.relationships.reactionsCount,
                              commentsCount: post.relationships.commentsCount,
                              totalSharesCount: post.relationships.post!.relationships.totalSharesCount,
                              authorId: post.relationships.user.id,
                              currentUserId: _id!,
                              onDeleteTap: () {
                                postId_ = post.attributes.postId;
                                _deletePost(post.id);
                              },
                              onEditTap: () {
                                input['body']!.text = post.attributes.body ?? '';
                                showPostPopup(context, input['body']!.text, post.id, mediaUrls, isVerified);
                              },
                              // Repost
                              bodyRepost: post.relationships.post!.attributes.body,
                              usernameUserRepost: post.relationships.post!.relationships.user.username,
                              createdAtRepost: post.relationships.post!.attributes.createdAt,
                              profilePhotoUserRepost: post.relationships.post!.relationships.user.profilePhotoUrl ?? '',
                              mediaUrlsRepost: mediaUrlsRepost,
                              onPostTap: (){ 
                                int postId = post.relationships.post!.id;
                                Navigator.pushNamed(
                                  context,
                                  'show-post',
                                  arguments: {
                                    'id': postId,
                                  }
                                  ).then((_) {
                                  postId_ = post.relationships.post!.id;
                                  _callPost();
                                });
                              },
                              onRepostTap: () { 
                                int postId = post.relationships.post!.id;
                                Navigator.pushNamed(
                                  context,
                                  'new-repost',
                                  arguments: {
                                    'postId': postId,
                                  },
                                ).then((_) {
                                  _callPost();
                                });
                              },
                              onReportTap: () {
                                int postId = post.id;
                                _showReportDialog(postId, context);
                              },
                              onShareTap: () {
                                int postId = post.relationships.post!.id;
                                _postShare(postId, context);
                              }, 
                              isVerified: isVerified,
                              isVerifiedRepost: post.relationships.post?.relationships.user.groupId?.contains(1) == true ||
                              post.relationships.post?.relationships.user.groupId?.contains(2) == true, 
                            );
                          }
                        },
                      padding: EdgeInsets.only(bottom: _hasMorePages ? 0 : 70.0),
                      ),
                    ),
                ),
              ],
            ),
          ),
    );
  }
}