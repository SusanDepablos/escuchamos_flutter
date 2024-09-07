import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Api/Model/UserModels.dart'; // Cambié a UserModels
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Command/UserCommand.dart'; // Cambié a UserCommand
import 'package:escuchamos_flutter/Api/Service/UserService.dart'; // Cambié a UserService
import 'package:escuchamos_flutter/App/Widget/Users/UserListView.dart';

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

  List<Datum> users = []; // Cambié a Datum
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;

  Future<void> fetchUsers() async {
    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;

    if (widget.name_?.isNotEmpty ?? false) {
      filters['name'] = widget.name_;
    }

    filters['page'] =
        widget.page.toString(); // Asegúrate de que esto no sea null

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
      users.clear(); // Cambié a users
      _hasMorePages = true;
    });
    fetchUsers(); // Cambié a fetchUsers
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_hasMorePages) {
            // Solo cargar más si hay más páginas
            setState(() {
              widget.page++;
              fetchUsers(); // Cambié a fetchUsers
            });
          }
        }
      });
    fetchUsers(); // Cambié a fetchUsers
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            UserListView(
                users: users,
                scrollController: _scrollController), // Cambié a users
          ],
        ),
      ),
    );
  }
}
