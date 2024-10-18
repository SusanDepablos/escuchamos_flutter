import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Command/ShareCommand.dart';
import 'package:escuchamos_flutter/Api/Model/ShareModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/Api/Service/ShareService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/ShowConfirmationDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/RepostListView.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/ProfileAvatar.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/CustomRefreshIndicator.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart' as user_model;
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

String _formatDate(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inSeconds < 60) {
    return difference.inSeconds == 1 ? "hace 1 s" : "hace ${difference.inSeconds} s";
  } else if (difference.inMinutes < 60) {
    return difference.inMinutes == 1 ? "hace 1 min" : "hace ${difference.inMinutes} min";
  } else if (difference.inHours < 24) {
    return difference.inHours == 1 ? "hace 1 h" : "hace ${difference.inHours} h";
  } else if (difference.inDays < 7) {
    return difference.inDays == 1 ? "hace 1 d" : "hace ${difference.inDays} d";
  } else if (difference.inDays < 30) {
    return "el ${createdAt.day} ${_getAbbreviatedMonthName(createdAt.month)}";
  } else {
    return "el ${createdAt.day} ${_getAbbreviatedMonthName(createdAt.month)} de ${createdAt.year}";
  }
}

String _getAbbreviatedMonthName(int month) {
  const monthNames = [
    "ene", "feb", "mar", "abr", "may", "jun",
    "jul", "ago", "sep", "oct", "nov", "dic"
  ];
  return monthNames[month - 1];
}


class IndexShare extends StatefulWidget {
  final int? userId;
  IndexShare({this.userId});
  @override
  _IndexShareState createState() => _IndexShareState();
}

class _IndexShareState extends State<IndexShare> {
  late ScrollController _scrollController;
  List<Datum> shares = [];
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  int page = 1;
  int? _id;
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchShares();
          }
        }
      });
    _getData()
        .then((_) => _callUser());
    fetchShares();
  }

  Future<void> _getData() async {
    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });
  }

  Future<void> _reloadShares() async {
    setState(() {
      page = 1;
      shares.clear();
      _hasMorePages = true;
      _initialLoading = true;
    });
    await fetchShares();
  }

  Future<void> fetchShares() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    if (widget.userId != null) {
      filters['user_id'] = widget.userId?.toString();
    }

    filters['page'] = page.toString();

    final postCommand = ShareCommandIndex(ShareIndex(), filters);

    try {
      var response = await postCommand.execute();

      if (response is SharesModel) {
        setState(() {
          shares.addAll(response.results.data);
          _hasMorePages = response.next != null && response.next!.isNotEmpty;
          page++;
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

  Future<void> _deleteShare(int id) async {
    try {
      var response = await DeleteCommandShare(ShareDelete()).execute(id: id);

      if (response is SuccessResponse) {
        setState(() {
            // Eliminar todos los shares que coincidan con cualquiera de las dos condiciones
            shares.removeWhere((share) => share.id == id);
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

  void _onDeleteItem(BuildContext context, int shareId) {
    showConfirmationDialog(
      context,
      title: 'Confirmar eliminación',
      content: '¿Estás seguro de que quieres eliminarlo? Esta acción no se puede deshacer.',
      onConfirmTap: () {
        _deleteShare(shareId);
      },
    );
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

  void _showOptionsModal(BuildContext context, int shareId, int userId, int postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteapp,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_id == userId) ...[
                ListTile(
                  leading: const Icon(CupertinoIcons.delete_solid, color: AppColors.errorRed),
                  title: const Text(
                    'Eliminar',
                    style: TextStyle(color: AppColors.errorRed, fontSize: AppFond.subtitle),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el modal primero
                    _onDeleteItem(context, shareId); // Mostrar el diálogo de confirmación
                  },
                ),
              ]else ...[
                ListTile(
                    leading: const Icon(MaterialIcons.report, color: AppColors.errorRed),
                    title: const Text(
                      'Reportar',
                      style: TextStyle(color: AppColors.errorRed, fontSize: AppFond.subtitle),
                    ),
                    onTap: () {
                       Navigator.pop(context); // Cerrar el modal
                      _showReportDialog(postId, context);
                    },
                  ),
              ]
            ],
          ),
        );
      },
    );
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
                child: shares.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay compartidos.',
                          style: TextStyle(
                            fontSize: AppFond.subtitle,
                            color: AppColors.black,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      )
                    : CustomRefreshIndicator(
                        onRefresh: _reloadShares,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: shares.length + (_isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == shares.length) {
                                return SizedBox(
                                  height: 60.0,
                                  child: Center(
                                    child: CustomLoadingIndicator(
                                        color: AppColors.primaryBlue),
                                  ),
                                );
                              }
                            final share = shares[index];
                            String username = share.relationships.user.username;
                            int userId = share.relationships.user.id;
                            bool showShares = true;
                            String? profilePhotoUserShare =
                                share.relationships.user.profilePhotoUrl;
                            DateTime createdAt = share.attributes.createdAt;
                            final mediaUrls = share.relationships.post.relationships.files
                                .map((file) => file.attributes.url)
                                .toList();
                            bool isVerified = share.relationships.user.groupId != null && 
                            (share.relationships.user.groupId!.contains(1) || 
                            share.relationships.user.groupId!.contains(2));
                            return
                              Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16), // Margen arriba y abajo
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 0,
                              bottom: 0,),
                            decoration: BoxDecoration(
                              color: AppColors.greyLigth, // Color de fondo
                              borderRadius: BorderRadius.circular(24), // Borde redondeado
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: userId != _id, // Mostrar solo si el userId es diferente al _id
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.userId == null) {
                                            Navigator.pushNamed(
                                              context,
                                              'profile',
                                              arguments: {
                                                'showShares': showShares, // Coloca las claves entre comillas
                                                'userId': userId,
                                              },
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            ProfileAvatar(
                                              imageProvider: profilePhotoUserShare != null &&
                                                      profilePhotoUserShare.isNotEmpty
                                                  ? NetworkImage(profilePhotoUserShare)
                                                  : null,
                                              avatarSize: AppFond.avatarSizeShare,
                                              iconSize: AppFond.iconSizeShare,
                                              showBorder: false,
                                              onPressed: () {
                                                if (widget.userId == null) {
                                                  Navigator.pushNamed(
                                                    context,
                                                    'profile',
                                                    arguments: {
                                                      'showShares': showShares,
                                                      'userId': userId,
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 230),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      username,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: AppFond.username,
                                                      ),
                                                      textScaleFactor: 1.0,
                                                      overflow: TextOverflow.ellipsis, // Recortar con puntos suspensivos si es demasiado largo
                                                      maxLines: 1, // Limitar a una sola línea
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  if (isVerified)
                                                    const Icon(
                                                      CupertinoIcons.checkmark_seal_fill,
                                                      size: AppFond.iconVerified,
                                                      color: AppColors.primaryBlue,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          _showOptionsModal(
                                            context,
                                            share.id,
                                            share.relationships.user.id,
                                            share.attributes.postId,
                                          );
                                        },
                                        child: const Icon(
                                          CupertinoIcons.ellipsis,
                                          color: AppColors.grey,
                                          size: AppFond.iconMore,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: userId != _id,
                                  child: RichText(
                                    textScaleFactor: 1.0, // Ajuste de textScaleFactor
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: AppFond.subtitle,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.grey,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Ha compartido esta publicación ',
                                        ),
                                        TextSpan(
                                          text: _formatDate(createdAt),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                  visible: userId == _id,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: RichText(
                                          textScaleFactor: 1.0, // Ajuste de textScaleFactor
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: AppFond.subtitle,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.grey,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: 'Haz compartido esta publicación ',
                                              ),
                                              TextSpan(
                                                text: _formatDate(createdAt),
                                              ),
                                            ],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          _showOptionsModal(
                                            context,
                                            share.id,
                                            share.relationships.user.id,
                                            share.attributes.postId,
                                          );
                                        },
                                        child: const Icon(
                                          CupertinoIcons.ellipsis,
                                          color: AppColors.grey,
                                          size: AppFond.iconMore,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (userId == _id) 
                                  const SizedBox(height: 10),
                                PostWidgetInternal(
                                  usernameUser: share.relationships.post.relationships.user.username,
                                  profilePhotoUser: share.relationships.post.relationships.user.profilePhotoUrl,
                                  createdAt: share.relationships.post.attributes.createdAt,
                                  mediaUrls: mediaUrls,
                                  body: share.relationships.post.attributes.body,
                                  onTap: (){ 
                                  int postId = share.attributes.postId;
                                  Navigator.pushNamed(
                                    context,
                                    'show-post',
                                    arguments: {
                                      'id': postId,
                                    }
                                  );
                                  },
                                  color: AppColors.whiteapp, // Transparente ya que el container tiene fondo
                                  margin: const EdgeInsets.only(
                                    left: 0,
                                    right: 0,
                                    top: 0,
                                    bottom: 20.0,
                                  ),
                                  isVerified: share.relationships.post.relationships.user.groupId?.contains(1) == true ||
                                  share.relationships.post.relationships.user.groupId?.contains(2) == true, 
                                ),
                              ],
                            ),
                        );
                      },
                    padding: EdgeInsets.only(bottom: _hasMorePages ? 0 : 70.0),
                    )
                  ),
              ),
            ],
          ),
        ),
    );
  }
}