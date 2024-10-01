import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/PostPopup.dart';
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

final FlutterSecureStorage _storage = FlutterSecureStorage();
int postId_ = 0 ;
int idPost = 0;
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
  String? _name;
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

  Future<void> _callPostShow() async {
    try {
      final postCommand = PostCommandShow(PostShow(), idPost);
      final response = await postCommand.execute();

      if (mounted) {
        if (response is PostModel) {
          if (idPost != 0) {
            setState(() {
              _post = response;
              String? body =_post!.data.relationships.post!.attributes.body;
              // Itera sobre todos los posts y actualiza el body donde se encuentre el postId.
              for (var post in posts) {
                if (post.attributes.postId == postId_ && post.relationships.post != null) {
                  post.relationships.post!.attributes.body = body;
                }
              }
            });
          }
        } else {
          // await showDialog(
          //   context: context,
          //   builder: (context) => AutoClosePopupFail(
          //         child: const FailAnimationWidget(),
          //         message: response.message,
          //       ));
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
          idPost = 0;
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

  void showPostPopup(BuildContext context, String? body, int postId){
    postId_ = postId;
    showDialog(
      context: context,
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
                nameUser: _name!,
                profilePhotoUser: _profilePhotoUser,
                error: _errorMessages['body'],
                body: body!,
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
          _name = _user!.data.attributes.name;
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
      var response = await DeleteCommandPost(DeletePost()).execute(id: id);

      if (response is SuccessResponse) {
        setState(() {
            // Eliminar todos los posts que coincidan con cualquiera de las dos condiciones
            posts.removeWhere((post) => post.id == id || post.attributes.postId == id);
        });
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
                          final mediaUrlsRepost = post.relationships.post?.relationships.files.map((file) => file.attributes.url).toList();
                          final bool hasReaction = reactionStates[post.id]!;

                          if (post.attributes.postId == null) {
                            // Si existe el postId, devolvemos el PostWidget
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
                                ).then((_) {
                                  _callPost();
                                });
                              },
                              body: post.attributes.body,
                              mediaUrls: mediaUrls,
                              createdAt: post.attributes.createdAt,
                              reactionsCount: post.relationships.reactionsCount.toString(),
                              commentsCount: post.relationships.commentsCount.toString(),
                              sharesCount: post.relationships.totalSharesCount.toString(),
                              authorId: post.relationships.user.id,
                              currentUserId: _id!,
                              onDeleteTap: () {
                                _deletePost(post.id);
                              },
                              onEditTap: () {
                                input['body']!.text = post.attributes.body ?? '';
                                showPostPopup(context, input['body']!.text, post.id);
                              },
                            );
                          } else {
                            return RepostWidget(
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
                                ).then((_) {
                                  _callPost();
                                });
                              },
                              body: post.attributes.body,
                              createdAt: post.attributes.createdAt,
                              reactionsCount: post.relationships.reactionsCount.toString(),
                              commentsCount: post.relationships.commentsCount.toString(),
                              sharesCount: post.relationships.totalSharesCount.toString(),
                              authorId: post.relationships.user.id,
                              currentUserId: _id!,
                              onDeleteTap: () {
                                _deletePost(post.id);
                              },
                              onEditTap: () {
                                input['body']!.text = post.attributes.body ?? '';
                                showPostPopup(context, input['body']!.text, post.id);
                              },
                              // Repost
                              bodyRepost: post.relationships.post!.attributes.body,
                              nameUserRepost: post.relationships.post!.relationships.user.name,
                              usernameUserRepost: post.relationships.post!.relationships.user.username,
                              createdAtRepost: post.relationships.post!.attributes.createdAt,
                              profilePhotoUserRepost: post.relationships.post!.relationships.user.profilePhotoUrl ?? '',
                              mediaUrlsRepost: mediaUrlsRepost,
                              onPostTap: (){ 
                                int postId = post.relationships.post!.id;
                                int idPost = post.id;
                                Navigator.pushNamed(
                                  context,
                                  'show-post',
                                  arguments: {
                                    'id': postId,
                                    'idPost':idPost,
                                  }
                                  ).then((_) {
                                  _callPost(); _callPostShow();
                                });
                              },
                              onProfileTapRepost: () {
                                final userId = post.relationships.post!.relationships.user.id;
                                Navigator.pushNamed(
                                  context,
                                  'profile',
                                  arguments: userId,
                                );
                              }
                            );
                          }
                        }
                      ),
                    ),
                ),
              ],
            ),
          ),
    );
  }
}