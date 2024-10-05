import 'dart:ffi';

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
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final FlutterSecureStorage _storage = FlutterSecureStorage();
class IndexManageUser extends StatefulWidget {
  String? search_;
  int page = 1;
  VoidCallback? onFetchUsers;

  IndexManageUser({this.search_, this.onFetchUsers});

  @override
  _IndexManageUserState createState() => _IndexManageUserState();
}

class _IndexManageUserState extends State<IndexManageUser> {
  List<Map<String, dynamic>> groupData = [];
  List<Datum> users = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _isInitialLoading = true;
  int _id =  0;

  final filters = {
    'pag': '10',
    'page': null,
    'search': null,
  };

  Future<void> reloadView() async {
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
    _callGroups();
    fetchUsers();
  }

  FileElement? getProfileFile(List<FileElement> files) {
    return files.where((file) => file.attributes.type == 'profile').isNotEmpty
        ? files.firstWhere((file) => file.attributes.type == 'profile')
        : null;
  }

  Future<void> fetchUsers() async {
    if (_isLoading || !_hasMorePages) return;

    final id = await _storage.read(key: 'user') ?? '';

    setState(() {
      _id = int.parse(id);
    });

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
            users.addAll(response.results.data.where((user) => user.id != _id));
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
                'id': datum.id,
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

void _showChangeRoleDialog(BuildContext context, roles, userGroup, userId) {
    int? selectedRole = userGroup;

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
                      selectedValue: selectedRole,
                      items: roles,
                      onChanged: (value) {
                        setState(() {
                          selectedRole =
                              value; // Actualiza selectedRole al cambiar
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
                      onPressed: () async {
                        if (selectedRole != null) {
                          int groupId = selectedRole!;

                          await _updateGroup(groupId, userId, context);
                          Navigator.of(context).pop(); // Cerrar diálogo de cambio de rol
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

  Future<void> _updateGroup(int groupId, int id, BuildContext context) async {
    try {

      var response = await GroupCommandUpdate(GroupUpdate()).execute(groupId, id);

      if (response is SuccessResponse) {
        reloadView();
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
                            int userGroup = user.relationships.groups[0].id;
                            int userId = user.id;

                            showModalBottomSheet(
                              context: context,
                                builder: (BuildContext context) {
                                  return UserOptionsModal(
                                    showChangeRoleDialog: () => _showChangeRoleDialog(context, groupData, userGroup, userId), // Pasar la función correctamente
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
