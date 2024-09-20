import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:escuchamos_flutter/App/View/User/Index.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación
        children: [
          const SizedBox(height: 20), // Espacio en la parte superior del SearchInput
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
    if (_searchText.isEmpty) {
      return Center(child: Text(''));
    }
    return IndexUser(
      search_: _searchText,
    );
  }

}
