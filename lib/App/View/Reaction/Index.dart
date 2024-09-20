
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
// import 'package:escuchamos_flutter/App/Widget/Ui/Button.dart';
import 'package:escuchamos_flutter/Api/Model/ReactionModels.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Command/ReactionCommand.dart';
import 'package:escuchamos_flutter/Api/Service/ReactionService.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/User/UserListView.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

class IndexReactions extends StatefulWidget {
  VoidCallback? onFetchReactions;
  int page = 1;
  String model;
  String objectId;
  String appBar;

  IndexReactions({
    this.onFetchReactions,
    required this.objectId,
    required this.model,
    required this.appBar});

  @override
  _IndexReactionsState createState() => _IndexReactionsState();
}

class _IndexReactionsState extends State<IndexReactions> {
  final filters = {
    'pag': '10',
    'page': null,
    'model': null,
    'object_id': null,
  };

  List<Datum> reactions = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;

  Future<void> fetchReactions() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    filters['page'] = widget.page.toString();
    filters['object_id'] = widget.objectId.toString();
    filters['model'] = widget.model.toString();

    final userCommand = ReactionsCommandIndex(ReactionsIndex(), filters);

    try {
      var response = await userCommand.execute();

      if (mounted) {
        if (response is ReactionsModel) {
          setState(() {
            reactions.addAll(response.results.data);
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
      reactions.clear();
      _hasMorePages = true;
    });
    fetchReactions();
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
              fetchReactions();
            });
          }
        }
      });
    fetchReactions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Aquí agregué la propiedad appBar sin cambiar estilos
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.appBar,
                style: const TextStyle(
                  fontSize: AppFond.title,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black, // No se cambió el color
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.whiteapp,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _isLoading
                ? CustomLoadingIndicator(color: AppColors.primaryBlue) // Mostrar el widget de carga mientras esperamos la respuesta
                : reactions.isEmpty
                  ? const Center(
                    child: Text(
                      'Sin resultados.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                  controller: _scrollController,
                  itemCount: reactions.length,
                  itemBuilder: (context, index) {
                  final datum = reactions[index];
                  final user = datum.relationships.user;
                    return UserListView(
                      nameUser: user.name,
                      usernameUser: user.username,
                      profilePhotoUser: user.profilePhotoUrl ?? '',
                      onProfileTap: () {
                        final userId = user.id;
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
