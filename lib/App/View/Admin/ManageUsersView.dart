import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:escuchamos_flutter/App/View/Admin/IndexManageUser.dart';

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
      setState(() {
        _searchText = _searchController.text;
      });
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
      backgroundColor: AppColors.whiteapp, // Estilo de fondo
      appBar: AppBar(
        backgroundColor: AppColors.whiteapp,
        centerTitle: true,
        toolbarHeight: 50, // Ajusta según sea necesario
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
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación
        children: [
          const SizedBox(height: 10), // Espacio en la parte superior del SearchInput
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
