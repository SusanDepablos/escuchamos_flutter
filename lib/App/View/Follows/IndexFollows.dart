
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
// import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Api/Model/FollowModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Command/FollowsCommand.dart';
import 'package:escuchamos_flutter/Api/Service/FollowsService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/User/UserListView.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loadings/LoadingBasic.dart';

class IndexFollows extends StatefulWidget {
  String? searchFollowing_;
  int page = 1;
  String followedUserId;
  VoidCallback? onFetchFollows;

  IndexFollows({this.searchFollowing_, this.onFetchFollows, required this.followedUserId});

  @override
  _IndexFollowsState createState() => _IndexFollowsState();
}

class _IndexFollowsState extends State<IndexFollows> {
  final filters = {
    'pag': '10',
    'page': null,
    'search_following': null,
    'followed_user_id': null,
  };

  List<Datum> follows = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;

  Future<void> fetchFollows() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    if (widget.searchFollowing_?.isNotEmpty ?? false) {
      filters['search_following'] = widget.searchFollowing_;
    }

    filters['page'] = widget.page.toString();
    filters['followed_user_id'] = widget.followedUserId.toString();

    final userCommand = FollowsCommandIndex(FollowsIndex(), filters);

    try {
      var response = await userCommand.execute();

      if (mounted) {
        if (response is FollowsModel) {
          setState(() {
            follows.addAll(response.results.data);
            _hasMorePages = response.next != null && response.next!.isNotEmpty;
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => PopupWindow(
              title: response is InternalServerError
                  ? 'Error'
                  : 'Error de Conexión',
              message: response.message ?? 'Ocurrió un error desconocido',
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
            title: 'Error',
            message: e.toString(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  void reloadView() {
    setState(() {
      widget.page = 1;
      follows.clear();
      _hasMorePages = true;
    });
    fetchFollows();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (!_isLoading && _hasMorePages) {
            setState(() {
              widget.page++;
              fetchFollows();
            });
          }
        }
      });
    fetchFollows();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _isLoading
                ? CustomLoadingIndicator(color: AppColors.primaryBlue) // Mostrar el widget de carga mientras esperamos la respuesta
                : follows.isEmpty
                  ? const Center(
                    child: Text(
                      'No existen usuarios con ese nombre.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                  controller: _scrollController,
                  itemCount: follows.length,
                  itemBuilder: (context, index) {
                    final list = follows[index];
                    final followingUser = list.attributes.followingUser;
                    return UserListView(
                      nameUser:
                          followingUser.name,
                      usernameUser: followingUser.username,
                      profilePhotoUser: followingUser.profilePhotoUrl ?? '',
                      onProfileTap: () {
                        final userId = followingUser.id;
                        Navigator.pushNamed(
                          context,
                          'profile',
                          arguments: userId,
                        );
                      },
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}
