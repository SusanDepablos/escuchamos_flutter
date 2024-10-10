import 'package:escuchamos_flutter/Api/Command/ReportCommand.dart';
import 'package:escuchamos_flutter/Api/Model/ReportModels.dart';
import 'package:escuchamos_flutter/Api/Response/InternalServerError.dart';
import 'package:escuchamos_flutter/Api/Service/ReportService.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/PopupWindow.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/CustomRefreshIndicator.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingScreen.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Report/ReportListView.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class IndexReportRepost extends StatefulWidget {
  @override
  _IndexReportRepostState createState() => _IndexReportRepostState();
}

class _IndexReportRepostState extends State<IndexReportRepost> {
  List<Datum> reportsGrouped = [];
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMorePages = true;
  bool _initialLoading = true;
  int page = 1;

  final filters = {
    'pag': '10',
    'page': null,
    'object_type': 'repost',
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (_hasMorePages && !_isLoading) {
            fetchReportsGrouped();
          }
        }
      });
    fetchReportsGrouped();
  }

  Future<void> _reloadReportsGrouped() async {
    setState(() {
      page = 1;
      reportsGrouped.clear();
      _hasMorePages = true;
      _initialLoading = true;
    });
    await fetchReportsGrouped();
  }

  Future<void> fetchReportsGrouped() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    filters['page'] = page.toString();

    final reportGroupedCommand = ReportGroupedCommandIndex(ReportGroupedIndex(), filters);

    try {
      var response = await reportGroupedCommand.execute();

      if (response is ReportsGroupedModel) {
        setState(() {
          reportsGrouped.addAll(response.results.data);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      body: _initialLoading
        ? const LoadingScreen(
            animationPath: 'assets/animation.json',
            verticalOffset: -0.3,
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: reportsGrouped.isEmpty
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
                        onRefresh: _reloadReportsGrouped,
                        child: ListView.builder(
                        controller: _scrollController,
                        itemCount: reportsGrouped.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == reportsGrouped.length) {
                            return SizedBox(
                              height: 60.0,
                              child: Center(
                                child: CustomLoadingIndicator(
                                    color: AppColors.primaryBlue),
                              ),
                            );
                          }
                          final report = reportsGrouped[index];
                          final mediaUrlsRepost = report.relationships.post?.relationships.post?.relationships.files.map((file) => file.attributes.url).toList();
                          return RepostSimpleWidget(
                            nameUser: report.relationships.post?.relationships.user.name ?? '...', 
                            usernameUser: report.relationships.post?.relationships.user.username ?? '...', 
                            profilePhotoUser: report.relationships.post?.relationships.user.profilePhotoUrl,
                            createdAt: report.relationships.post?.attributes.createdAt ?? DateTime.now(), 
                            body: report.relationships.post?.attributes.body,
                            nameUserRepost: report.relationships.post?.relationships.post?.relationships.user.name ?? '...',
                            usernameUserRepost: report.relationships.post?.relationships.post?.relationships.user.username ?? '...',
                            createdAtRepost: report.relationships.post?.relationships.post?.attributes.createdAt ??  DateTime.now(), 
                            bodyRepost: report.relationships.post?.relationships.post?.attributes.body,
                            mediaUrlsRepost: mediaUrlsRepost,
                            onRepostTap: (){}
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