import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Ui/Input.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:escuchamos_flutter/App/View/Follow/IndexFollowers.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/Loading/LoadingBasic.dart';

class SearchFollowers extends StatefulWidget {
  String followedUserId;

  SearchFollowers(
    {required this.followedUserId});

  @override
  _SearchFollowersState createState() => _SearchFollowersState();
}

class _SearchFollowersState extends State<SearchFollowers> {
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
    return IndexFollowers(
      searchFollowing_: _searchText,
      followedUserId: widget.followedUserId,
    );
  }

}
