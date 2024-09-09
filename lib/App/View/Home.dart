import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Model/PostModels.dart';
import 'package:escuchamos_flutter/Api/Command/PostCommand.dart';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Posts/PostList.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loadings/CustomRefreshIndicator.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loadings/LoadingScreen.dart'; // Importa el widget de pantalla de carga

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Datum> posts = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true; // Variable para el estado de carga inicial
  int page = 1;

  final filters = {
    'pag': '10',
    'page': null,
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchPosts();
          }
        }
      });
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    filters['page'] = page.toString();

    final postCommand = PostCommandIndex(PostIndex(), filters);

    try {
      var response = await postCommand.execute();

      if (response is PostsModel) {
        setState(() {
          posts.addAll(response.results.data);
          _hasMorePages = response.next != null && response.next!.isNotEmpty;
          page++; // Incrementar la página solo si la respuesta es exitosa
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error',
            message: response is InternalServerError ? 'Error de servidor' : 'Error de conexión',
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
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initialLoading = false; // Después de la primera carga, ya no mostrar la pantalla de carga
        });
      }
    }
  }

  Future<void> _reloadPosts() async {
    setState(() {
      page = 1;
      posts.clear();
      _hasMorePages = true;
    });
    await fetchPosts();
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
      body: _initialLoading
          ? LoadingScreen(
              animationPath: 'assets/animation.json',
              verticalOffset: -0.3, // Mueve la animación hacia arriba
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: CustomRefreshIndicator(
                      onRefresh: _reloadPosts,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostWidget(
                            nameUser: post.relationships.user.name,
                            usernameUser: post.relationships.user.username,
                            profilePhotoUser: post.relationships.user.profilePhotoUrl,
                            onProfileTap: () async {
                              final userId = post.relationships.user.id; // Convierte el ID a int si es necesario
                              await Navigator.pushNamed(
                                  context, 
                                  'profile', 
                                  arguments: userId, // Pasa el ID como argumento
                                );
                              },
                            body: post.attributes.body,
                            mediaUrl: post.relationships.files.firstOrNull?.attributes.url,
                            createdAt: post.attributes.createdAt,
                            reactionsCount: post.relationships.reactionsCount.toString(),
                            commentsCount: post.relationships.commentsCount.toString(),
                            sharesCount: post.relationships.sharesCount.toString(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
