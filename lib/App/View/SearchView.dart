import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:escuchamos_flutter/App/View/User/Index/Index.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Estilo de padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación
          children: [
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
                future: _fetchCountries(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  } else {
                    return snapshot.data!;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _fetchCountries() async {
    if (_searchText.isEmpty) {
      return Center(child: Text(''));
    }
    return Index(
      search_: _searchText,
    );
  }
}
