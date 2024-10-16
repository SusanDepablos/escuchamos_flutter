import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
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
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Comment/CommentPopupCreate.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Comment/CommentPopupUpdate.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';
import 'dart:io';

final FlutterSecureStorage _storage = FlutterSecureStorage();
int commentId_ = 0;
bool? likeState;

class IndexComment extends StatefulWidget {
  final int? postId;
  final int? commentId;

  IndexComment({this.postId, this.commentId});

  @override
  _IndexCommentState createState() => _IndexCommentState();
}

class _IndexCommentState extends State<IndexComment> {
  List<Datum> comments = [];
  Map<int, bool> reactionStates = {};
  late ScrollController _scrollController;
  CommentModel? _comment;
  user_model.UserModel? _user;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  int _id = 0;
  int page = 1;
  String? _username;
  String? _profilePhotoUser;
  bool _submitting = false;
  bool _isAddButtonVisible = false;
  int? groupId;
  bool isVerified = false;

  final Map<String, String?> _errorMessages = {
    'body': null,
  };

  void _clearErrorMessages() {
    setState(() {
      _errorMessages['body'] = null;
    });
  }

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
    _getData().then((_) => _callUser());
    postId_ = widget.postId!;
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
      _id = int.parse(id);
    });
  }

  Future<void> _callComment() async {
    final commentCommand = CommentCommandShow(CommentShow(), commentId_);

    try {
      final response = await commentCommand.execute();

      if (mounted) {
        if (response is CommentModel) {
          setState(() {
            _comment = response;

            int commentIndex =
                comments.indexWhere((comment) => comment.id == commentId_);

            if (commentIndex >= 0 && commentIndex < comments.length) {
              comments[commentIndex].relationships.reactionsCount =
                  _comment!.data.relationships.reactionsCount;

              comments[commentIndex].relationships.repliesCount =
                  _comment!.data.relationships.repliesCount;

              comments[commentIndex].attributes.body =
                  _comment!.data.attributes.body;

              final bool userLikedComment = _comment!
                  .data.relationships.reactions
                  .any((reaction) => reaction.attributes.userId == _id);

              reactionStates[commentId_] = userLikedComment;
            }
          });
        } else {
          setState(() {
            int commentIndex =
                comments.indexWhere((comment) => comment.id == commentId_);
            if (commentIndex != -1) {
              comments.removeAt(commentIndex);
            }
          });
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
    } finally {
      if (mounted) {
        setState(() {
          commentId_ = 0;
        });
      }
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
          groupId = _user!.data.relationships.groups[0].id;
          isVerified = groupId == 1 || groupId == 2;
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
      filters['comment_id'] = widget.commentId.toString();
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

          for (var comment in response.results.data) {
            reactionStates[comment.id] = comment.relationships.reactions.any(
              (reaction) => reaction.attributes.userId == _id,
            );
          }
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
        _isAddButtonVisible = true;
      });
    }
  }

  void showCommentPopup(
    BuildContext context, {
    String? body,
    String? mediaUrl,
  }) {
    _clearErrorMessages();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: CommentPopupCreateWidget(
                onCancel: () {
                  _clearErrorMessages();
                  Navigator.of(context).pop();
                },
                isButtonDisabled: _submitting,
                username: _username ?? '...',
                profilePhotoUser: _profilePhotoUser,
                onCommentCreate: (String body, String? mediaUrl) async {
                  await _commentCreate(body, mediaUrl, context, setState);
                },
                error: _errorMessages['body'],
                isVerified: isVerified,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _commentCreate(String body, String? mediaUrl,
      BuildContext context, Function setState) async {
    setState(() {
      _submitting = true;
    });

    try {
      formData['post_id'] = widget.postId.toString();

      if (widget.commentId != null) {
        formData['comment_id'] = widget.commentId.toString();
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
          });
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _errorMessages['body'] = null;
            });
          });
        }
      } else if (response is SuccessResponse) {
        Navigator.of(context).pop();
        _reloadComment();
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
          title: 'Error',
          message: e.toString(),
        ),
      );
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }  

void updateCommentPopup(
    BuildContext context, {
    required String body,
    String? mediaUrl,
    required int comentarioId,
  }) {
    _clearErrorMessages();
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
              child: CommentPopupUpdateWidget(
                onCancel: () {
                  _clearErrorMessages();
                  Navigator.of(context).pop();
                },
                isButtonDisabled: _submitting,
                username: _username ?? '...',
                profilePhotoUser: _profilePhotoUser,
                body: body,
                mediaUrl: mediaUrl,
                onCommentUpdate: (String body, String? mediaUrl) async {
                  await _updateComment(
                      body, comentarioId, setStateLocal, context);
                },
                error: _errorMessages['body'],
                isVerified: isVerified,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateComment(String body, int commentId, Function setStateLocal,
      BuildContext context) async {
    try {

      var response = await CommentCommandUpdate(CommentUpdate()).execute(body, commentId);

      if (response is ValidationResponse) {
        print(response.message('body'));
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
      }  else if (response is SuccessResponse) {
        setStateLocal(() {
          int commentIndex = comments.indexWhere((comment) => comment.id == commentId);
          if (commentIndex != -1) {
            comments[commentIndex].attributes.body = body;
          }
        });
        Navigator.of(context).pop();
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

  Future<void> _commentReaction(int index, int id) async {
    if (index < 0 || index >= comments.length) return;

    try {
      var response =
          await ReactionCommandPost(ReactionPost()).execute('comment', id);
      commentId_ = id;

      if (response is SuccessResponse) {
        await _callComment();
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

  Future<void> _deleteComment(int id, BuildContext context) async {
    try {
      var response = await CommentCommandDelete(CommentDeleteService()).execute(id);

      if (response is SuccessResponse) {
        setState(() {
          int commentIndex =
              comments.indexWhere((comment) => comment.id == id);
          if (commentIndex != -1) {
            comments.removeAt(commentIndex);
          }
        });

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

  void _showReportDialog(commentId, BuildContext context) {
    List<Map<String, dynamic>> observationData = [
      {
        'id': 1,
        'name': 'Contenido inapropiado',
      },
      {
        'id': 2,
        'name': 'Spam o auto-promoción',
      },
      {
        'id': 3,
        'name': 'Desinformación',
      },
      {
        'id': 4,
        'name': 'Acoso o intimidación',
      },
      {
        'id': 5,
        'name': 'Otro',
      },
    ];

    // Inicializa con el primer valor
    String? selectedObservation = observationData[0]['name']; // "Contenido inapropiado"

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: 'Reportar Comentario',
              content: 'Por favor, selecciona la razón para reportar esta comentario:',
              selectWidget: SelectBasic(
                hintText: 'Observación',
                // Mostrar el valor predeterminado seleccionado
                selectedValue: observationData.firstWhere((item) => item['name'] == selectedObservation)['id'],
                items: observationData,
                onChanged: (value) {
                  setState(() {
                    // Actualiza el selectedObservation al cambiar
                    selectedObservation = observationData.firstWhere((item) => item['id'] == value)['name'];
                  });
                },
              ),
              onAccept: () async {
                if (selectedObservation != null && !_submitting) { // Asegúrate de que no esté en envío
                  setState(() {
                    _submitting = true; // Bloquear el botón
                  });
                  await _postReport(commentId, selectedObservation!, context); // Enviar el name seleccionado
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

  Future<void> _postReport(int commentId, String observation, BuildContext context) async {
    try {
      var response =  await ReportCommandPost(ReportPost()).execute('comment', commentId, observation);
      if (response is SuccessResponse) {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(), // Aquí se pasa la animación
            message: response.message,
          ),
        );
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
          visible: widget.commentId == null || widget.commentId == 0.toString(),
          child: AppBar(
            backgroundColor: AppColors.whiteapp,
            centerTitle: true,
            title: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Comentarios',
                  style: TextStyle(
                    fontSize: AppFond.title,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                  textScaleFactor: 1.0
                ),
              ],
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
                                    fontSize: AppFond.subtitle,
                                    color: AppColors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              )
                            : CustomRefreshIndicator(
                                onRefresh: _reloadComment,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: comments.length + (_isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == comments.length) {
                                      return SizedBox(
                                        height: 60.0,
                                        child: Center(
                                          child: CustomLoadingIndicator(
                                              color: AppColors.primaryBlue),
                                        ),
                                      );
                                    }
                                    final comment = comments[index];
                                    final bool hasReaction = reactionStates[comment.id]!;  // Aquí se asegura de que tome el estado actualizado
                                    return CommentWidget(
                                      authorId: comment.attributes.userId,
                                      currentUserId: _id,
                                      reaction: hasReaction,
                                      onLikeTap: () => _commentReaction(index, comment.id),
                                      usernameUser: comment.relationships.user.username,
                                      profilePhotoUser: comment.relationships.user.profilePhotoUrl ?? '',
                                      onProfileTap: () {
                                        int userId = comment.relationships.user.id;
                                        Navigator.pushNamed(context, 'profile', arguments: {'showShares': false, 'userId': userId},);
                                      },
                                      onResponseTap: () {
                                        int commentId = comment.id;
                                        Navigator.pushNamed(context, 'nested-comments', arguments: commentId)
                                            .then((_) {
                                          commentId_ = commentId;
                                          _callComment();
                                        });
                                      },
                                      onNumberLikeTap: () {
                                        int objectId = comment.id;
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

                                      onDeleteTap: () {
                                        _deleteComment(comment.id, context);
                                      },

                                    onEditTap: () {
                                      String body = comment.attributes.body ?? '';  // El body actual
                                      String? mediaUrl = comment.relationships.file.firstOrNull?.attributes.url;  // La URL de la imagen, si existe
                                      updateCommentPopup(context, body: body, mediaUrl: mediaUrl, comentarioId: comment.id);
                                    },
                                    onReportTap: () {
                                      int commentId = comment.id;
                                      _showReportDialog(commentId, context);
                                    },
                                    body: comment.attributes.body,
                                    mediaUrl: comment.relationships.file.firstOrNull?.attributes.url,
                                    createdAt: comment.attributes.createdAt,
                                    reactionsCount: comment.relationships.reactionsCount.toString(),
                                    repliesCount: comment.relationships.repliesCount.toString(),
                                    isVerified:comment.relationships.user.groupId?.contains(1) == true ||
                                    comment.relationships.user.groupId?.contains(2) == true,
                                    );
                                    
                                  },
                                  // padding: EdgeInsets.only(bottom: _hasMorePages ? 0 : 70.0),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
          if (_isAddButtonVisible)
            FloatingAddButton(
              onTap: () {
                showCommentPopup(context);
              },
            )
        ],
      ),
    );
  }
}