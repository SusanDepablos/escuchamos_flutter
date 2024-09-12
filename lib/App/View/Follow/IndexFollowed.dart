
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

class IndexFollowed extends StatefulWidget {
  String? searchfollowed_;
  int page = 1;
  String followingUserId;
  VoidCallback? onFetchFollowers;

  IndexFollowed({this.searchfollowed_, this.onFetchFollowers, required this.followingUserId});

  @override
  _IndexFollowedState createState() => _IndexFollowedState();
}

class _IndexFollowedState extends State<IndexFollowed> {
  final filters = {
    'pag': '10',
    'page': null,
    'search_followed': null,
    'following_user_id': null,
  };

  List<Datum> followed = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;

  Future<void> fetchfollowed() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    if (widget.searchfollowed_?.isNotEmpty ?? false) {
      filters['search_followed'] = widget.searchfollowed_;
    }

    filters['page'] = widget.page.toString();
    filters['following_user_id'] = widget.followingUserId.toString();

    final userCommand = FollowsCommandIndex(FollowsIndex(), filters);

    try {
      var response = await userCommand.execute();

      if (mounted) {
        if (response is FollowsModel) {
          setState(() {
            followed.addAll(response.results.data);
            _hasMorePages = response.next != null && response.next!.isNotEmpty;
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
      followed.clear();
      _hasMorePages = true;
    });
    fetchfollowed();
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
              fetchfollowed();
            });
          }
        }
      });
    fetchfollowed();
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
                : followed.isEmpty
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
                  itemCount: followed.length,
                  itemBuilder: (context, index) {
                    final list = followed[index];
                    final followedUser = list.attributes.followedUser;
                    return UserListView(
                      nameUser:
                          followedUser.name,
                      usernameUser: followedUser.username,
                      profilePhotoUser: followedUser.profilePhotoUrl ?? '',
                      onProfileTap: () {
                        final userId = followedUser.id;
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