import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
// import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/User/UserListView.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

class IndexUser extends StatefulWidget {
  String? search_;
  int page = 1;
  VoidCallback? onFetchUsers;

  IndexUser({this.search_, this.onFetchUsers});

  @override
  _IndexUserState createState() => _IndexUserState();
}

class _IndexUserState extends State<IndexUser> {
  final filters = {
    'pag': '10',
    'page': null,
    'search': null,
  };

  List<Datum> users = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _isInitialLoading = true;

  void reloadView() {
    setState(() {
      widget.page = 1;
      users.clear();
      _hasMorePages = true;
      _isInitialLoading = false;
    });
    fetchUsers();
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
              fetchUsers();
            });
          }
        }
      });
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    if (_isInitialLoading) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    if (widget.search_?.isNotEmpty ?? false) {
      filters['search'] = widget.search_;
    }

    filters['page'] = widget.page.toString();

    final userCommand = UserCommandIndex(UserIndex(), filters);

    try {
      var response = await userCommand.execute();

      if (mounted) {
        if (response is UsersModel) {
          setState(() {
            users.addAll(response.results.data);
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
          _isInitialLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  FileElement? getProfileFile(List<FileElement> files) {
    return files.where((file) => file.attributes.type == 'profile').isNotEmpty
        ? files.firstWhere((file) => file.attributes.type == 'profile')
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp, // Estilo de fondo
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: _isInitialLoading
                  ? CustomLoadingIndicator(color: AppColors.primaryBlue) // Mostrar el widget de carga mientras esperamos la respuesta
                  : users.isEmpty
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
                      itemCount: users.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == users.length) {
                          return SizedBox(
                            height: 60.0,
                            child: Center(
                              child: CustomLoadingIndicator(
                                  color: AppColors.primaryBlue),
                            ),
                          );
                        }
                        final user = users[index];
                        final profileFile = getProfileFile(user.relationships.files);
                        bool isVerified = user.relationships.groups.any((group) => group.id == 1 || group.id == 2);
                        return UserListView(
                          nameUser: user.attributes.name,
                          usernameUser: user.attributes.username,
                          profilePhotoUser: profileFile?.attributes.url ?? '',
                          onTap: () {
                            final userId = user.id; // Obtén el ID del usuario
                            Navigator.pushNamed(
                              context,
                              'profile',
                              arguments: {'showShares': false, 'userId': userId}, // Pasa el ID como argumento
                            );
                          },
                          onPhotoUserTap: () {
                            final userId = user.id; // Obtén el ID del usuario
                            Navigator.pushNamed(
                              context,
                              'profile',
                              arguments: {'showShares': false, 'userId': userId}, // Pasa el ID como argumento
                            );
                          },
                          isVerified: isVerified,
                        );
                      },
                      padding: EdgeInsets.only(bottom: _hasMorePages ? 0 : 70.0),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
