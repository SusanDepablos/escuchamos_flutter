import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
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
import 'package:escuchamos_flutter/App/View/Comment/Index.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Comment/CommentPopupCreate.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Comment/CommentPopupUpdate.dart';

FlutterSecureStorage _storage = FlutterSecureStorage();

class NestedComments extends StatefulWidget {
  final int commentId;

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
  String? _repliesCount;
  int? postId;
  int _id = 0;
  bool _submitting = false;
  String? _profilePhotoUser;
  List<bool> reactionStates = [false];

  final Map<String, String?> _errorMessages = {
    'body': null,
  };

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';
    setState(() {
      _id = int.parse(id);
    });
  }

  @override
  void initState() {
    _getData();
    commentId_ = widget.commentId;
    super.initState();
    _callComment();
  }

  void _clearErrorMessages() {
    setState(() {
      _errorMessages['body'] = null;
    });
  }

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
            _profilePhotoUrl = _comment?.data.relationships.user.profilePhotoUrl;
            _body = _comment?.data.attributes.body;
            _mediaUrl = _comment?.data.relationships.file.firstOrNull?.attributes.url;
            _reactionsCount = _comment!.data.relationships.reactionsCount.toString();
            _repliesCount = _comment!.data.relationships.repliesCount.toString();
            postId = _comment!.data.attributes.postId;
            reactionStates[0] = _comment!.data.relationships.reactions.any(
            (reaction) => reaction.attributes.userId == _id);
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
        print('primero');
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

void updateCommentPopup(
    BuildContext context, {
    String? body,
    String? mediaUrl,
    required int comentarioId,
  }) {
    _clearErrorMessages();
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
              child: CommentPopupUpdateWidget(
                onCancel: () {
                  _clearErrorMessages();
                  Navigator.of(context).pop();
                },
                isButtonDisabled: _submitting,
                nameUser: _name.toString(),
                profilePhotoUser: _profilePhotoUser,
                body: body,
                mediaUrl: mediaUrl,
                onCommentUpdate: (String body, String? mediaUrl) async {
                  await _updateComment(
                      body, comentarioId, setStateLocal, context);;
                },
                error: _errorMessages['body'],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _commentReaction(int index, int id) async {
    if (index < 0 || index >= reactionStates.length) return;

    try {
      var response = await ReactionCommandPost(ReactionPost()).execute('comment', id);

      if (response is SuccessResponse) {
          await _callComment();
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

  Future<void> _updateComment(String body, int commentId,
      Function setStateLocal, BuildContext context) async {
    try {
      var response = await CommentCommandUpdate(CommentUpdate()).execute(body, commentId);

      if (response is ValidationResponse) {
        if (response.key['body'] != null) {
          if (mounted) {
            setStateLocal(() {
              _errorMessages['body'] = response.message('body');
            });
          }
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setStateLocal(() {
                _errorMessages['body'] = null;
              });
            }
          });
        }
      } else if (response is SuccessResponse) {
        await _callComment();
        if (mounted) {
          Navigator.of(context).pop();
        }
        showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(),
            message: response.message,
          ),
        );
      } else {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AutoClosePopupFail(
              child: const FailAnimationWidget(),
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
            title: 'Error',
            message: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _deleteComment(int id, BuildContext context) async {
    try {
      var response = await CommentCommandDelete(CommentDeleteService()).execute(id);

      if (response is SuccessResponse) {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(),
            message: response.message,
          ),      
        );

        Navigator.pop(context);
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
              acceptButtonEnabled: !_submitting, // Habilitar/deshabilitar el botóns
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
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        title: const Text(
          'Respuestas',
          style: TextStyle(
            fontSize: AppFond.title,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
      ),
      body: _comment == null
          ? const LoadingScreen(
              animationPath: 'assets/animation.json', verticalOffset: -0.3)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommentWidget(
                          reaction: reactionStates[0],
                          onLikeTap: () => _commentReaction(0, _comment!.data.id),
                          nameUser: _name.toString(),
                          usernameUser: _username.toString(),
                          profilePhotoUser: _profilePhotoUrl ?? '',
                          onProfileTap: () {
                            int userId = _comment!.data.relationships.user.id;
                            Navigator.pushNamed(context, 'profile',
                              arguments: {'showShares': false, 'userId': userId},);
                          },
                          
                          onNumberLikeTap: () {
                          int objectId = _comment!.data.id;
                          Navigator.pushNamed(
                            context,
                            'index-reactions',
                            arguments: {
                              'objectId': objectId,
                              'model': 'comment',
                              'appBar': 'Reacciones'
                            },
                          );
                        },
                          body: _body,
                          mediaUrl: _mediaUrl,
                          createdAt: _comment!.data.attributes.createdAt,
                          reactionsCount: _reactionsCount.toString(),
                          repliesCount: _repliesCount.toString(),

                          authorId: _comment!.data.relationships.user.id,
                          currentUserId: _id,
                          onEditTap: () {
                            updateCommentPopup(context, body: _body, mediaUrl: _mediaUrl, comentarioId: _comment!.data.id);
                          },

                        onDeleteTap: () {
                          _deleteComment(_comment!.data.id, context);
                        },
                          onReportTap: () {
                            int commentId = _comment!.data.id;
                            _showReportDialog(commentId, context);
                          },
                          isHidden: true,
                        ),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor:
                            0.9,
                        child: IndexComment(
                          commentId: widget.commentId,
                          postId: postId,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
