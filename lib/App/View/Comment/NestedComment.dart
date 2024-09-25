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
import 'dart:math';

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
  String? postId;
  List<bool> reactionStates = [false];

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
            postId = _comment!.data.attributes.postId.toString();
            commentId_ = widget.commentId;
            likeState = null;
            _setReactionState();
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
        print(e);
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

  Future<void> _setReactionState() async {
    final userId = await _storage.read(key: 'user') ?? '0';
    setState(() {
      reactionStates[0] = _comment!.data.relationships.reactions
          .any((reaction) => reaction.attributes.userId == int.parse(userId));
    });
  }

  Future<void> _commentReaction(int index, int id) async {
    if (index < 0 || index >= reactionStates.length) return;

    try {
      var response = await ReactionCommandPost(ReactionPost()).execute('comment', id);

      if (response is SuccessResponse) {
        setState(() {
          bool hasReaction = reactionStates[index];
          likeState = !hasReaction;
          reactionStates[index] = !hasReaction;

          if (_comment != null) {
            if (reactionStates[index]) {
              _comment!.data.relationships.reactionsCount++;
            } else {
              _comment!.data.relationships.reactionsCount =
                  max(0, _comment!.data.relationships.reactionsCount - 1);
            }
            _reactionsCount = _comment!.data.relationships.reactionsCount.toString();
          }
        });
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

  @override
  void initState() {
    super.initState();
    _callComment();
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
                            final userId = _comment!.data.relationships.user.id;
                            Navigator.pushNamed(context, 'profile',
                                arguments: userId);
                          },
                          
                          onNumberLikeTap: () {
                          String objectId = _comment!.data.id.toString();
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
                          commentId: widget.commentId.toString(),
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
