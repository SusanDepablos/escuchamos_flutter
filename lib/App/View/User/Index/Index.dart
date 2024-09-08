import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart';
import 'package:escuchamos_flutter/Api/Service/UserService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/User/UserListView.dart';

class Index extends StatefulWidget {
  String? name_;
  int page = 1;
  VoidCallback? onFetchUsers;

  Index({this.name_, this.onFetchUsers});

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final filters = {
    'pag': '10',
    'page': null,
    'name': null,
  };

  List<Datum> users = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;

  Future<void> fetchUsers() async {
    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;

    if (widget.name_?.isNotEmpty ?? false) {
      filters['name'] = widget.name_;
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
            // Asignar URLs de archivos si es necesario
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
          if (_hasMorePages) {
            setState(() {
              widget.page++;
              fetchUsers();
            });
          }
        }
      });
    fetchUsers();
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
      appBar: AppBar(title: Text('Index')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            GenericButton(label: 'Recargar Vista', onPressed: reloadView),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final profileFile = getProfileFile(user.relationships.files);

                  return UserListView(
                    name: user.attributes.name ?? 'Nombre no disponible',
                    email: user.attributes.email ?? 'Email no disponible',
                    phoneNumber: user.attributes.phoneNumber ?? 'Número no disponible',
                    url: profileFile?.attributes.url ?? '',
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
