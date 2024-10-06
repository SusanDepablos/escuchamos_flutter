import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/View/Follow/SearchFollowers.dart';
import 'package:escuchamos_flutter/App/View/Follow/SearchFollowed.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';

class NavigatorFollow extends StatefulWidget {
  final String initialTab;
  final int userId;

  NavigatorFollow({required this.initialTab, required this.userId});

  @override
  _NavigatorFollowState createState() => _NavigatorFollowState();
}

class _NavigatorFollowState extends State<NavigatorFollow> {
  late int _initialIndex;
  UserModel? _user;
  String? name;
  String? username;
  int? followers;
  int? following;
  bool _isUserCalled = false;

  Future<void> _callUser() async {
    final id = widget.userId;
    final userCommand = UserCommandShow(UserShow(), id);

    try {
      final response = await userCommand.execute();

      if (mounted) {
        if (response is UserModel) {
          setState(() {
            _user = response;
            name = _user!.data.attributes.name;
            followers = _user!.data.relationships.followersCount;
            following = _user!.data.relationships.followingCount;
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
      setState(() {
        _isUserCalled = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _callUser();
    if (widget.initialTab == 'follower') {
      _initialIndex = 0;
    } else if (widget.initialTab == 'followed') {
      _initialIndex = 1;
    } else {
      _initialIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de tabs
      initialIndex: _initialIndex,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: AppColors.whiteapp,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name ?? "...",
                    style: const TextStyle(
                      fontSize: AppFond.title,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              isScrollable: false,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor: AppColors.black,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: AppColors.primaryBlue,
                      width: 3.0,
                ),
                insets: EdgeInsets.symmetric(
                    horizontal: 16.0),
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${followers ?? 0}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text('Seguidores'),      
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${following ?? 0}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text('Seguidos'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _isUserCalled
          ? TabBarView(
              children: [
                SearchFollowers(followedUserId: widget.userId),
                SearchFollowed(followingUserId: widget.userId),
              ],
            )
          : Container(),
      ),
    );
  }
}
