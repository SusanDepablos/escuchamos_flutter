import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Model/ReportModels.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/CustomRefreshIndicator.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Report/ReportListView.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Model/PostModels.dart';
import 'package:escuchamos_flutter/Api/Command/PostCommand.dart';
import 'package:escuchamos_flutter/Api/Service/PostService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart';

class ShowReportPost extends StatefulWidget {
  final int postId;

  ShowReportPost({required this. postId});

  @override
  _ShowReportPostState createState() => _ShowReportPostState();
}

class _ShowReportPostState extends State<ShowReportPost> {
  PostModel? _post;
  String? _name;
  String? _username;
  String? _profilePhotoUrl;
  String? _body;
  DateTime? _createdAt;
  List<String>? _mediaUrls;
  List<String>? _mediaUrlsRepost;
  List<ReportsDatum> reports = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  int page = 1;
  bool _submitting = false;
  bool _isResolved = false;


  final filters = {
    'pag': '10',
    'page': null,
    'model': 'post',
    'object_id': null
  };


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchReports();
          }
        }
      });
    _callPost(); 
    fetchReports();
  }


  Future<void> _callPost() async {
    final postCommand = PostCommandShow(PostShow(), widget.postId);
    try {
      final response = await postCommand.execute();
      if (mounted) {
        if (response is PostModel) {
          setState(() {
            _post = response; // Establecer _post aquí
            _name = _post?.data.relationships.user.name;
            _username = _post?.data.relationships.user.username;
            _profilePhotoUrl = _post?.data.relationships.user.profilePhotoUrl;
            _body = _post?.data.attributes.body;
            _createdAt = _post?.data.attributes.createdAt;
            _mediaUrls = _post?.data.relationships.files.map((file) => file.attributes.url).toList();
            _mediaUrlsRepost =  _post?.data.relationships.post?.relationships.files.map((file) => file.attributes.url).toList() ?? [];
          
            _isResolved = _post?.data.attributes.statusId == 4 || _post?.data.attributes.statusId == 3;
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
      if (mounted) {
        print(e.toString());
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: e.toString(),
          ),
        );
      }
    }
  }
  
  Future<void> _reloadReports() async {
    setState(() {
      page = 1;
      reports.clear();
      _hasMorePages = true;
      _initialLoading = true;
    });
    await fetchReports();
  }

  Future<void> fetchReports() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });
    filters['object_id'] = widget.postId.toString();
    filters['page'] = page.toString();

    final reportCommand = ReportCommandIndex(ReportIndex(), filters);

    try {
      var response = await reportCommand.execute();

      if (response is ReportsModel) {
        setState(() {
          reports.addAll(response.results.data);
          _hasMorePages = response.next != null && response.next!.isNotEmpty;
          page++;
          
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: response is InternalServerError ? 'Error de servidor' : 'Error de conexión',
            message: response.message,
          ),
        );
      }
    } catch (e) {
      print(e);
        showDialog(
          context: context,
          builder: (context) => PopupWindow(
            title: 'Error de Flutter',
            message: 'Espera un poco, pronto lo solucionaremos.',
          ),
        );
      }
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initialLoading = false;
        });
      }
    }
  }

    void _showReportDialog(BuildContext context) {
    List<Map<String, dynamic>> statusData = [
      {'id': 3, 'name': 'Resolver'},
      {'id': 4, 'name': 'Bloquear'},
    ];
    int? selectedStatus = 3;
    int commentId = widget.postId;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: 'Administrar Publicación',
              selectWidget: SelectBasic(
                hintText: 'Estados',
                selectedValue: selectedStatus,
                items: statusData,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
              onAccept: () async {
                if (selectedStatus != null && !_submitting) {
                  setState(() {
                    _submitting = true; 
                  });
                  await _updateReport(commentId, selectedStatus!, context);
                  setState(() {
                    _submitting = false;
                  });
                  Navigator.of(context).pop();
                  _callPost();
                }
              },
            acceptButtonEnabled: !_submitting, 
            );
          },
        );
      },
    );
  }

  
  Future<void> _updateReport(int postId, int statusId, BuildContext context) async {
    try {
      var response = await ReportCommandUpdate(ReportUpdate()).execute('post', postId, statusId);
      String message = statusId == 3 ? 'Publicación Solucionada.' : 'Publicación Bloqueada.';
      if (response is SuccessResponse) {
        await showDialog(
          context: context,
          builder: (context) => AutoClosePopup(
            child: const SuccessAnimationWidget(),
            message: message,
          ),
        );
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
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        title: Text(
          'Publicación de ${_name ?? '...'}',
          style: const TextStyle(
            fontSize: AppFond.title,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Muestra el PostWidgetInternal o RepostSimpleWidget según la condición
            _post?.data.attributes.postId == null
              ? PostWidgetInternal(
                  nameUser: _name ?? '...', // Usar un valor por defecto
                  usernameUser: _username ?? '...',
                  profilePhotoUser: _profilePhotoUrl,
                  createdAt: _createdAt ?? DateTime.now(), // Usar un valor por defecto
                  body: _body,
                  mediaUrls: _mediaUrls,
                  color: AppColors.greyLigth,
                  margin: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  avatarSize: 40.0,
                  iconSize: 26.0,
                  onProfileTap: () {
                    int userId = _post!.data.relationships.user.id;
                    Navigator.pushNamed(
                      context,
                      'profile',
                      arguments: {
                        'showShares': false,
                        'userId': userId,
                      },
                    );
                  },
                  onTap:  () {
                  if (!_isResolved) {
                    _showReportDialog(context);
                  } else {
                    // Opcional: Muestra un mensaje si el comentario ya está resuelto
                    showDialog(
                      context: context,
                      builder: (context) => PopupWindow(
                        title: 'Publicación Solucionada',
                        message: 'Esta publicación ya fue solucionada.',
                      ),
                    );
                  }
                },
              )
              : RepostSimpleWidget(
                  nameUser: _name ?? '...',
                  usernameUser: _username ?? '...',
                  profilePhotoUser: _profilePhotoUrl,
                  createdAt: _createdAt ?? DateTime.now(),
                  nameUserRepost: _post?.data.relationships.post?.relationships.user.name ?? '...',
                  usernameUserRepost: _post?.data.relationships.post?.relationships.user.username ?? '...',
                  profilePhotoUserRepost: _post?.data.relationships.post?.relationships.user.profilePhotoUrl,
                  createdAtRepost: _post?.data.relationships.post?.attributes.createdAt ?? DateTime.now(),
                  bodyRepost: _post?.data.relationships.post?.attributes.body,
                  mediaUrlsRepost: _mediaUrlsRepost,
                  onProfileTap: () {
                    int userId = _post!.data.relationships.user.id;
                    Navigator.pushNamed(
                      context,
                      'profile',
                      arguments: {
                        'showShares': false,
                        'userId': userId,
                      },
                    );
                  },
                  onRepostTap: () {
                    if (!_isResolved) {
                    _showReportDialog(context);
                    } else {
                      // Opcional: Muestra un mensaje si el comentario ya está resuelto
                      showDialog(
                        context: context,
                        builder: (context) => PopupWindow(
                          title: 'Publicación Solucionada',
                          message: 'Esta publicación ya fue solucionada.',
                        ),
                      );
                    }
                  },
                ),
            // Título "Reportes"
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Reportes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            // Mostrar la pantalla de carga mientras se realiza la carga inicial
            if (_initialLoading)
              const LoadingScreen(
                animationPath: 'assets/animation.json',
                verticalOffset: -0.3,
              )
            else
              // Mostrar la lista de reportes cuando se hayan cargado
              Center(
                child: reports.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay Reportes.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      )
                    : CustomRefreshIndicator(
                        onRefresh: _reloadReports,
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reports.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == reports.length) {
                              return SizedBox(
                                height: 60.0,
                                child: Center(
                                  child: CustomLoadingIndicator(color: AppColors.primaryBlue),
                                ),
                              );
                            }
                            final report = reports[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Center(
                                child: ReportUserWidget(
                                  nameUser: report.relationships.user.name,
                                  usernameUser: report.relationships.user.username,
                                  createdAt: report.attributes.createdAt,
                                  profilePhotoUser: report.relationships.user.profilePhotoUrl,
                                  observation: report.attributes.observation,
                                  report: 'publicación',
                                ),
                              ),
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