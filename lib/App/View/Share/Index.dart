import 'package:escuchamos_flutter/Api/Command/ShareCommand.dart';
import 'package:escuchamos_flutter/Api/Model/ShareModels.dart';
import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ShareService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
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

final FlutterSecureStorage _storage = FlutterSecureStorage();

String _formatDate(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inSeconds < 60) {
    return difference.inSeconds == 1 ? "1 s" : "${difference.inSeconds} s";
  } else if (difference.inMinutes < 60) {
    return difference.inMinutes == 1 ? "1 min" : "${difference.inMinutes} min";
  } else if (difference.inHours < 24) {
    return difference.inHours == 1 ? "1 h" : "${difference.inHours} h";
  } else if (difference.inDays < 7) {
    return difference.inDays == 1 ? "1 d" : "${difference.inDays} d";
  } else if (difference.inDays < 30) {
    return "${createdAt.day} ${_getAbbreviatedMonthName(createdAt.month)}";
  } else {
    return "${createdAt.day} ${_getAbbreviatedMonthName(createdAt.month)} de ${createdAt.year}";
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
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      )
                    : CustomRefreshIndicator(
                        onRefresh: _reloadShares,
                        child: ListView.builder(
                        controller: _scrollController,
                        itemCount: shares.length,
                        itemBuilder: (context, index) {
                          final share = shares[index];
                          String name = share.relationships.user.name;
                          String? profilePhotoUserShare = share.relationships.user.profilePhotoUrl;
                          DateTime createdAt = share.attributes.createdAt;
                          final mediaUrls = share.relationships.post.relationships.files.map((file) => file.attributes.url).toList();
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16), // Margen arriba y abajo
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
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                      int userId = share.relationships.user.id;
                                        Navigator.pushNamed(
                                          context,
                                          'profile',
                                          arguments: userId,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          ProfileAvatar(
                                            imageProvider: profilePhotoUserShare != null && profilePhotoUserShare.isNotEmpty
                                                ? NetworkImage(profilePhotoUserShare)
                                                : null,
                                            avatarSize: 22.0,
                                            showBorder: false,
                                            onPressed: () {
                                              int userId = share.relationships.user.id;
                                              Navigator.pushNamed(
                                                context,
                                                'profile',
                                                arguments: userId,
                                              );
                                            }, // Puedes mantener esta función o manejarla en el GestureDetector
                                          ),
                                          Container(
                                            constraints: const BoxConstraints(maxWidth: 140),
                                            child: Text(
                                              name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatDate(createdAt),
                                      style: const TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Ha compartido esta publicación',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.grey
                                  ),
                                ),
                                const SizedBox(height: 10), // Espacio entre la foto y el texto
                                PostWidgetInternal(
                                  nameUser: share.relationships.post.relationships.user.name,
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
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ),
                ),
              ],
            ),
          ),
    );
  }
}