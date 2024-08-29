import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/Widget/Input.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

//historial de busqueda//
  void _addToSearchHistory(String query) {
    setState(() {
      // Añadir la búsqueda al principio del historial
      _searchHistory.insert(0, query);
      // Limitar el historial a las últimas 5 búsquedas
      if (_searchHistory.length > 5) {
        _searchHistory = _searchHistory.sublist(0, 5);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reemplaza la barra de búsqueda con el widget SearchInput
            SearchInput(
              input: _searchController,
              onSearch: () {
                String query = _searchController.text;
                if (query.isNotEmpty) {
                  _addToSearchHistory(query);
                  // Aquí puedes añadir la lógica para filtrar o buscar los resultados
                }
              },
              onClear: () {
                _searchController.clear();
                // Aquí puedes añadir la lógica para restablecer los resultados de búsqueda
              },
            ),
            SizedBox(height: 20),
            // Mostrar historial de búsqueda
            Text(
              'Historial de búsqueda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.history, color: AppColors.primaryBlue),
                    title: Text(
                      _searchHistory[index],
                      style: TextStyle(color: AppColors.black),
                    ),
                    onTap: () {
                      _searchController.text = _searchHistory[index];
                      // Puedes disparar una búsqueda automáticamente si es necesario
                      print('Seleccionado del historial: ${_searchHistory[index]}');
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
