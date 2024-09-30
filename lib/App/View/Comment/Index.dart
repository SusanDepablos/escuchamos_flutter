import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart' as user_model;
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
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FloatingCircle.dart';
import 'package:escuchamos_flutter/App/View/Post/Index.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Comment/CommentPopup.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'dart:io';

final FlutterSecureStorage _storage = FlutterSecureStorage();
int commentId_ = 0;
bool? likeState;

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
  CommentModel? _comment;
  user_model.UserModel? _user;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  int? _id;
  int page = 1;
  String? _name;
  String? _profilePhotoUser;

  final Map<String, String?> _errorMessages = {
    'body': null,
  };

  final filters = {
    'pag': '10',
    'page': null,
    'post_id': null,
    'comment_id': null
  };

  final Map<String, String?> formData = {
      'body': null,
      'comment_id': null,
      'post_id': null,
    };

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

@override
  void initState() {
    postId_ = int.parse(widget.postId!);
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchComments();
          }
        }
      });
    _getData()
        .then((_) => _callUser());
    fetchComments();
  }


  Future<void> _reloadComment() async {
    setState(() {
      page = 1;
      comments.clear();
      _hasMorePages = true;
      _initialLoading = true;
    });
    await fetchComments();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';
    setState(() {
      _id = int.tryParse(id);
    });
  }

  Future<bool> _commentCreate(String body, String? mediaUrl) async {
    try {
      formData['post_id'] = widget.postId;

      if (widget.commentId != null) {
        formData['comment_id'] = widget.commentId;
      }

      formData['body'] = body;

      var response = await CommentCommandCreate(CommentCreate()).execute(
        formData: formData,
        file: mediaUrl != null ? File(mediaUrl) : null,
      );

      if (response is ValidationResponse) {
        if (response.key['body'] != null) {
          setState(() {
            _errorMessages['body'] = response.message('body');
            print(_errorMessages['body']);
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _errorMessages['body'] = null;
            });
          });
        }
        return false;
      } else if (response is SuccessResponse) {
        _reloadComment();
        return true;
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is InternalServerError ? 'Error' : 'Error de Conexión',
            message: response.message,
          ),
        );
        return false;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error',
          message: e.toString(),
        ),
      );
      return false; // Indica que no fue exitoso
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
          comments.addAll(response.results.data);
          _hasMorePages = response.next != null && response.next!.isNotEmpty;
          page++;

          reactionStates = List.generate(comments.length, (index) {
            return comments[index].relationships.reactions.any(
                  (reaction) => reaction.attributes.userId == _id,
                );
          });
        });
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
      showDialog(
        context: context,
        builder: (context) => PopupWindow(
          title: 'Error de Flutter',
          message: 'Espera un poco, pronto lo solucionaremos.',
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _initialLoading = false;
      });
    }
  }

  Future<void> _callComment() async {
    final commentCommand = CommentCommandShow(CommentShow(), commentId_);

    try {
      final response = await commentCommand.execute();

      if (mounted) {
        if (response is CommentModel) {
          setState(() {
            _comment = response;

            int commentIndex = comments.indexWhere((comment) => comment.id == commentId_);

            if (commentIndex >= 0 && commentIndex < comments.length) {
              comments[commentIndex].relationships.reactionsCount =
                  _comment!.data.relationships.reactionsCount;

              comments[commentIndex].relationships.repliesCount =
                  _comment!.data.relationships.repliesCount;

              final bool userLikedComment = _comment!
                  .data.relationships.reactions
                  .any((reaction) => reaction.attributes.userId == _id);

              reactionStates[commentIndex] = userLikedComment;
            }
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
      if (mounted) {
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
          commentId_ = 0;
        });
      }
    }
  }


Future<void> _commentReaction(int index, int id) async {
    if (index < 0 || index >= comments.length) return;

    setState(() {
      reactionStates[index] =
          !reactionStates[index]; // Cambiar el estado de la reacción
    });

    try {
      var response =
          await ReactionCommandPost(ReactionPost()).execute('comment', id);
      commentId_ = id;

      if (response is SuccessResponse) {
        await _callComment();
      } else {
        setState(() {
          reactionStates[index] = !reactionStates[index];
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
      setState(() {
        reactionStates[index] = !reactionStates[index];
      });

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
      body: Stack(
        children: [
          _initialLoading
              ? const LoadingScreen(
                  animationPath: 'assets/animation.json',
                  verticalOffset: -0.3,
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
                                onRefresh: _reloadComment,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = comments[index];
                                    final bool hasReaction = reactionStates[index];  // Aquí se asegura de que tome el estado actualizado

                                    return CommentWidget(
                                      reaction: hasReaction,  // Usar siempre el estado actualizado de `reactionStates`
                                      onLikeTap: () => _commentReaction(index, comment.id),
                                      nameUser: comment.relationships.user.name,
                                      usernameUser: comment.relationships.user.username,
                                      profilePhotoUser: comment.relationships.user.profilePhotoUrl ?? '',
                                      onProfileTap: () {
                                        final userId = comment.relationships.user.id;
                                        Navigator.pushNamed(context, 'profile', arguments: userId);
                                      },
                                      onResponseTap: () {
                                        final commentId = comment.id;
                                        Navigator.pushNamed(context, 'nested-comments', arguments: commentId)
                                            .then((_) {
                                          _callComment();
                                        });
                                      },
                                      onNumberLikeTap: () {
                                        String objectId = comment.id.toString();
                                        Navigator.pushNamed(
                                          context,
                                          'index-reactions',
                                          arguments: {
                                            'objectId': objectId,
                                            'model': 'comment',
                                            'appBar': 'Reacciones',
                                          },
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
          FloatingAddButton(
            onTap: () {
              CommentPopup(
                context,
                nameUser: _name.toString(),
                profilePhotoUser: _profilePhotoUser,
                error: _errorMessages['body'], 
                onProfileTap: () {
                  final userId = _id;
                  Navigator.pushNamed(context, 'profile', arguments: userId).then((_) {
                    _callUser();
                  });
                },
                onCommentCreate: (String body, String? mediaUrl) async {
                  return await _commentCreate(body, mediaUrl);
                },
              );
            },
          )
        ],
      ),
    );
  }
}