import 'package:escuchamos_flutter/Api/Command/CommentCommand.dart';
import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Model/ReportModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Response/SuccessResponse.dart';
import 'package:escuchamos_flutter/Api/Service/CommentService.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDialog.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/SuccessAnimation.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Select.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/CustomRefreshIndicator.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/Api/Model/CommentModels.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Report/ReportListView.dart';

class ShowReportComment extends StatefulWidget {
  final int commentId;

  ShowReportComment({required this.commentId});

  @override
  _ShowReportCommentState createState() => _ShowReportCommentState();
}

class _ShowReportCommentState extends State<ShowReportComment> {
  CommentModel? _comment;
  String? _name;
  String? _username;
  String? _profilePhotoUrl;
  String? _body;
  String? _mediaUrl;
  DateTime? _createdAt;
  int? postId;
  List<ReportsDatum> reports = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  int page = 1;
  bool _submitting = false;
  bool _isResolved = false;
  bool _isVerified = false;

  final filters = {
    'pag': '10',
    'page': null,
    'model': 'comment',
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
    _callComment(); 
    fetchReports();
  }

  Future<void> _callComment() async {
    final commentCommand = CommentCommandShow(CommentShow(), widget.commentId);
    try {
      final response = await commentCommand.execute();

      if (mounted) {
        if (response is CommentModel) {
          setState(() {
            _comment = response;
            _name = _comment!.data.relationships.user.name;
            _username = _comment!.data.relationships.user.username;
            _profilePhotoUrl = _comment?.data.relationships.user.profilePhotoUrl;
            _createdAt = _comment?.data.attributes.createdAt;
            _body = _comment?.data.attributes.body;
            _mediaUrl = _comment?.data.relationships.file.firstOrNull?.attributes.url;
            postId = _comment!.data.attributes.postId;
            _isVerified = _comment?.data.relationships.user.groupId?.contains(1) == true ||
              _comment?.data.relationships.user.groupId?.contains(2) == true;
            _isResolved = _comment?.data.attributes.statusId == 4 || _comment?.data.attributes.statusId == 3;
              
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
    filters['object_id'] = widget.commentId.toString();
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
    int commentId = widget.commentId;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: 'Administrar Comentario',
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
                  _callComment();
                }
              },
            acceptButtonEnabled: !_submitting, 
            );
          },
        );
      },
    );
  }

  
  Future<void> _updateReport(int commentId, int statusId, BuildContext context) async {
    try {
      var response = await ReportCommandUpdate(ReportUpdate()).execute('comment', commentId, statusId);
      String message = statusId == 3 ? 'Comentario Solucionado.' : 'Comentario Bloqueado.';
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
        title: Row( // Asegura que el Row esté centrado
          children: [
            Text(
              'Comentario de ${_username ?? '...'}', // Usar un valor por defecto si _username es null
              style: const TextStyle(
                fontSize: AppFond.title,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 4), // Espaciado entre el texto y el ícono
            if (_isVerified) // Asegúrate de que isVerified esté definido
              const Icon(
                CupertinoIcons.checkmark_seal_fill, // Cambia este ícono según tus necesidades
                color: AppColors.primaryBlue, // Color del ícono
                size: 16, // Tamaño del ícono
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar el comentario
            CommentSimpleWidget(
              usernameUser: _username ?? '...',
              profilePhotoUser: _profilePhotoUrl,
              createdAt: _createdAt ?? DateTime.now(),
              mediaUrl: _mediaUrl,
              body: _body,
              onProfileTap: () {
                int userId = _comment!.data.relationships.user.id;
                Navigator.pushNamed(
                  context,
                  'profile',
                  arguments: {
                    'showShares': false,
                    'userId': userId,
                  },
                );
              },
              onCommentTap: () {
                // Verifica si el comentario ya está resuelto
                if (!_isResolved) {
                  _showReportDialog(context);
                } else {
                  // Opcional: Muestra un mensaje si el comentario ya está resuelto
                  showDialog(
                    context: context,
                    builder: (context) => PopupWindow(
                      title: 'Comentario Solucionado',
                      message: 'Este comentario ya fue solucionado.',
                    ),
                  );
                }
              },
              isVerified: _comment?.data.relationships.user.groupId?.contains(1) == true ||
                _comment?.data.relationships.user.groupId?.contains(2) == true,
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
                        shrinkWrap: true, // Asegura que la lista se ajuste al contenido
                        physics: const NeverScrollableScrollPhysics(), // Deshabilita el scroll interno
                        itemCount: reports.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == reports.length) {
                            return SizedBox(
                              height: 60.0,
                              child: Center(
                                child: CustomLoadingIndicator(
                                    color: AppColors.primaryBlue),
                              ),
                            );
                          }
                          final report = reports[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Margen alrededor del widget
                            child: Center( // Centra el contenido
                              child: ReportUserWidget(
                                usernameUser: report.relationships.user.username,
                                createdAt: report.attributes.createdAt,
                                profilePhotoUser: report.relationships.user.profilePhotoUrl,
                                observation: report.attributes.observation,
                                report: 'comentario',
                                isVerified: report.relationships.user.groupId?.contains(1) == true ||
                                report.relationships.user.groupId?.contains(2) == true,
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
