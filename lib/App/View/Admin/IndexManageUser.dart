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
import 'package:escuchamos_flutter/Api/Command/GroupCommand.dart';
import 'package:escuchamos_flutter/Api/Model/GroupModels.dart' as model_group;
import 'package:escuchamos_flutter/Api/Service/GroupService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/User/UserActionPopup.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart'; 

class IndexManageUser extends StatefulWidget {
  String? search_;
  int page = 1;
  VoidCallback? onFetchUsers;

  IndexManageUser({this.search_, this.onFetchUsers});

  @override
  _IndexManageUserState createState() => _IndexManageUserState();
}

class _IndexManageUserState extends State<IndexManageUser> {
  List<Map<String, String>> groupData = [];
  List<Datum> users = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _isInitialLoading = true;

  final filters = {
    'pag': '10',
    'page': null,
    'search': null,
  };

  void reloadView() {
    setState(() {
      widget.page = 1;
      users.clear();
      _hasMorePages = true;
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
    _callGroups();
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
        // Desbloquear solicitudes después de completar la carga
        setState(() {
          _isLoading = false;
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _callGroups() async {
    final countryCommand = GroupCommandIndex(GroupIndex());

    try {
      var response = await countryCommand.execute();

      if (mounted) {
        if (response is model_group.GroupsModel) {
          setState(() {
            groupData = response.data.map((datum) {
              return {
                'name': datum.attributes.name,
                'id': datum.id.toString(),
              };
            }).toList();
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

  void _showChangeRoleDialog(BuildContext context, roles, userGroup) {
    String? selectedRole;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Administrar rol',
                  style: TextStyle(
                    fontSize: AppFond.title,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectBasic(
                      hintText: 'Roles',
                      selectedValue: userGroup,
                      items: roles,
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cerrar diálogo
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        if (selectedRole != null) {
                          // Aquí puedes manejar el rol seleccionado
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
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
                child:
                _isInitialLoading
                    ? CustomLoadingIndicator(color: AppColors.primaryBlue)
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
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final profileFile = getProfileFile(user.relationships.files);
                        return UserListView(
                          nameUser: user.attributes.name,
                          usernameUser: user.attributes.username,
                          profilePhotoUser: profileFile?.attributes.url ?? '',
                          onPhotoUserTap: () {
                            final userId = user.id;
                            Navigator.pushNamed(
                              context,
                              'profile',
                              arguments: userId,
                            );
                          },
                          onTap: () {
                            String userGroup = user.relationships.groups[0].id.toString();

                            showModalBottomSheet(
                              context: context,
                                builder: (BuildContext context) {
                                  return UserOptionsModal(
                                    showChangeRoleDialog: () => _showChangeRoleDialog(context, groupData, userGroup), // Pasar la función correctamente
                                  );
                                }, 
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
