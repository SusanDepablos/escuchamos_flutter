import 'dart:ffi';

import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
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
        _isInitialLoading = true;
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
  
  void _showChangeRoleDialog(groupData, userGroup, userId, BuildContext context) {
    int? selectedGroup = userGroup;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: 'Administrar rol',
              selectWidget: SelectBasic(
                hintText: 'Roles',
                selectedValue: selectedGroup,
                items: groupData,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value; // Actualiza selectedGroup al cambiar
                  });
                },
              ),
              onAccept: () async {
                if (selectedGroup != null) {
                  int groupId = selectedGroup!;
                  await _updateGroup(groupId, userId, context); // Función para actualizar grupo
                }
              },
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
        Navigator.of(context).pop(); // Cierra el diálogo
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
                              arguments: {'showShares': false, 'userId': userId},
                            );
                          },
                          onTap: () {
                            int userGroup = user.relationships.groups[0].id;
                            int userId = user.id;

                            showModalBottomSheet(
                              context: context,
                                builder: (BuildContext context) {
                                  return UserOptionsModal(
                                    showChangeRoleDialog: () => _showChangeRoleDialog(groupData, userGroup, userId, context), // Pasar la función correctamente
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
