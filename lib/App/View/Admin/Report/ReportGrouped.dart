import 'package:escuchamos_flutter/App/View/Admin/Report/NavigatorReport.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class IndexReportGrouped extends StatefulWidget {
  @override
  _IndexReportGroupedState createState() => _IndexReportGroupedState();
}

class _IndexReportGroupedState extends State<IndexReportGrouped> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reportes',
              style: TextStyle(
                fontSize: AppFond.title,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
      body: NavigatorReport(
          initialTab: 'posts',
        ),
    );
  }
}