import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:escuchamos_flutter/App/View/Admin/Users/IndexManageUser.dart';

class ManageUsersView extends StatefulWidget {
  @override
  _ManageUsersViewState createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
  _searchController.addListener(() {
        if (_searchController.text != _searchText) {
          setState(() {
            _searchText = _searchController.text;
          });
        }
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteapp,
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        toolbarHeight: 50,
        title: const Text(
          'Administrar Usuarios',
          style: TextStyle(
            fontSize: AppFond.title,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SearchInput(
            input: _searchController,
            onSearch: () {
              setState(() {
                _searchText = _searchController.text;
              });
            },
            onClear: () {
              _searchController.clear();
              setState(() {
                _searchText = '';
              });
            },
          ),
          const SizedBox(height: 20), // Espaciado entre widgets
          Expanded(
            child: FutureBuilder<Widget>(
              future: _fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const SizedBox
                    .shrink(); // Muestra un widget vacío mientras no haya datos.
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> _fetchUsers() async {
    return IndexManageUser(
      search_: _searchText,
    );
  }

}

