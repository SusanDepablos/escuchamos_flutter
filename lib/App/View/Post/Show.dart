import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Command/ShareCommand.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/Api/Service/ShareService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/PostUpdatePopup.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/PostListView.dart';
import 'package:escuchamos_flutter/Api/Model/PostModels.dart';
import 'package:escuchamos_flutter/Api/Command/PostCommand.dart';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Command/ReactionCommand.dart';
import 'package:escuchamos_flutter/Api/Service/ReactionService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/App/View/Post/Index.dart';

FlutterSecureStorage _storage = FlutterSecureStorage();

class Show extends StatefulWidget {
  final int id;

  Show({required this.id});

  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  PostModel? _post;
  int? _id;
  int? _userId;
  String? _name;
  String? _username;
  String? _profilePhotoUrl;
  String? _body;
  DateTime? _createdAt;
  List<String>? _mediaUrls;
  int? _reactionsCount;
  int? _commentsCount;
  int? _totalSharesCount;
  bool? _reaction;
  bool _submitting = false;

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
    postId_ = widget.id;
    super.initState();
    _getData();
    _callPost();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });
  }

  Future<void> _callPost() async {
    final postCommand = PostCommandShow(PostShow(), widget.id);
    try {
      final response = await postCommand.execute();
      if (mounted) {
        if (response is PostModel) {
          setState(() {
            _post = response; // Establecer _post aquí
            _userId = _post?.data.relationships.user.id;
            _name = _post?.data.relationships.user.name;
            _username = _post?.data.relationships.user.username;
            _profilePhotoUrl = _post?.data.relationships.user.profilePhotoUrl;
            _body = _post?.data.attributes.body;
            _createdAt = _post?.data.attributes.createdAt;
            _mediaUrls = _post?.data.relationships.files.map((file) => file.attributes.url).toList();
            _reactionsCount = _post?.data.relationships.reactionsCount;
            _commentsCount = _post?.data.relationships.commentsCount;
            _totalSharesCount = _post?.data.relationships.totalSharesCount;
            _reaction = _post?.data.relationships.reactions.any((reaction) => reaction.attributes.userId == _id) ?? false;
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
        print(e.toString());
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _postReaction() async {
    try {
      var response =  await ReactionCommandPost(ReactionPost()).execute('post', widget.id);
      if (response is SuccessResponse) {
        await _callPost();
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

  Future<void> _deletePost() async {
    try {
      var response = await DeleteCommandPost(PostDelete()).execute(id: widget.id);

      if (response is SuccessResponse) {
          await showDialog(
            context: context,
            builder: (context) => AutoClosePopup(
              child: const SuccessAnimationWidget(),
              message: response.message,
            ),
          );
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
          message: 'Espera un poco, pronto lo solucionaremos.',
        ),
      );
    }
  }

  
  void _clearErrorMessages() {
    setState(() {
      _errorMessages['body'] = null; // Limpia el mensaje de error específico
    });
  }

  void showPostPopup(BuildContext context, String? body, int postId, mediaUrls){
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
              child: PopupPostWidget(
                isButtonDisabled: _submitting,
                username: _username!,
                nameUser: _name!,
                profilePhotoUser: _profilePhotoUrl,
                error: _errorMessages['body'],
                body: body!,
                mediaUrls: mediaUrls,
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
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(),
            message: response.message,
          ),
        );
        await _callPost();
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

  void _showReportDialog(postId, BuildContext context) {
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
        'name': 'Violación de derechos de autor',
      },
      {
        'id': 5,
        'name': 'Acoso o intimidación',
      },
      {
        'id': 6,
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
              title: 'Reportar Publicación',
              content: 'Por favor, selecciona la razón para reportar esta publicación:',
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
                if (selectedObservation != null) {
                  await _postReport(postId, selectedObservation!, context); // Enviar el name seleccionado
                  Navigator.of(context).pop(); // Cierra el diálogo
                }
              },
            );
          },
        );
      },
    );
  }

  Future<void> _postReport(int postId, String observation, BuildContext context) async {

    try {
      var response =  await ReportCommandPost(ReportPost()).execute('post', postId, observation);
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

  Future<void> _postShare(int postId,  BuildContext context) async {
    try {
      var response =  await ShareCommandPost(SharePost()).execute(postId);
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
        title: Text(
          'Publicación de ${_name ?? '...'}', // Usar un valor por defecto si _name es null
          style: const TextStyle(
            fontSize: AppFond.title,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
      ),
      body: _post == null
          ? const LoadingScreen(
              animationPath: 'assets/animation.json', verticalOffset: -0.3)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostWidget(
                          reaction: _reaction ?? false,
                          onLikeTap: () => _postReaction(),
                          nameUser: _name!,
                          usernameUser: _username!,
                          profilePhotoUser: _profilePhotoUrl ?? '',
                          onProfileTap: () {
                            Navigator.pushNamed(
                              context,
                              'profile',
                              arguments: {'showShares': false, 'userId': _userId},
                            ).then((_) {
                              _callPost();
                            });
                          },
                          onIndexLikeTap: () {
                            Navigator.pushNamed(
                              context,
                              'index-reactions',
                              arguments: {
                                'objectId': widget.id,
                                'model': 'post',
                                'appBar': 'Reacciones'
                              },
                            );
                          },
                          onIndexCommentTap: () {
                            Navigator.pushNamed(
                              context,
                              'index-comments',
                              arguments: {
                                'postId': widget.id,
                              },
                            ).then((_) {
                              _callPost();
                            });
                          },
                          body: _body,
                          mediaUrls: _mediaUrls,
                          createdAt: _createdAt!,
                          reactionsCount: _reactionsCount ?? 0,
                          commentsCount: _commentsCount ?? 0,
                          totalSharesCount: _totalSharesCount ?? 0,
                          authorId: _userId!,
                          currentUserId: _id!,
                          onDeleteTap: () {_deletePost();},
                          onEditTap: () {
                            input['body']!.text = _body ?? '';
                            showPostPopup(context, input['body']!.text, widget.id, _mediaUrls);
                          },
                          onReportTap: () {
                            int postId = widget.id;
                            _showReportDialog(postId, context);
                          },
                          onShareTap: () {
                            int postId = widget.id;
                            _postShare(postId, context);
                          }
                        )
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}