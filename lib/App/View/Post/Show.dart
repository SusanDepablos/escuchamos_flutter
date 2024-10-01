import 'package:escuchamos_flutter/Api/Response/ErrorResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Post/PostPopup.dart';
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
import 'dart:math';

FlutterSecureStorage _storage = FlutterSecureStorage();

class Show extends StatefulWidget {
  final int id;
  final int idPost;

  Show({required this.id, required this.idPost});

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
  String? _reactionsCount;
  String? _commentsCount;
  String? _totalSharesCount;
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
    idPost = widget.idPost;
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
            _reactionsCount = _post?.data.relationships.reactionsCount.toString();
            _commentsCount = _post?.data.relationships.commentsCount.toString();
            _totalSharesCount = _post?.data.relationships.totalSharesCount.toString();
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
      var response = await DeleteCommandPost(DeletePost()).execute(id: widget.id);

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

  void showPostPopup(BuildContext context, String? body, int postId){
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
                              arguments: _userId,
                            );
                          },
                          onIndexLikeTap: () {
                            Navigator.pushNamed(
                              context,
                              'index-reactions',
                              arguments: {
                                'objectId': widget.id.toString(),
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
                                'postId': widget.id.toString(),
                              },
                            ).then((_) {
                              _callPost();
                            });
                          },
                          body: _body,
                          mediaUrls: _mediaUrls,
                          createdAt: _createdAt!,
                          reactionsCount: _reactionsCount.toString(),
                          commentsCount: _commentsCount.toString(),
                          sharesCount: _totalSharesCount.toString(),
                          authorId: _userId!,
                          currentUserId: _id!,
                          onDeleteTap: () {_deletePost();},
                          onEditTap: () {
                            input['body']!.text = _body ?? '';
                            showPostPopup(context, input['body']!.text, widget.id);
                          },
                        )
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}