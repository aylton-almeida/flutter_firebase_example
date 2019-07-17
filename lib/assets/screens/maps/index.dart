import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController mapController;

  Icon _searchIcon = Icon(Icons.search);

  Widget _appBarTitle = Text('Maps');

  final TextEditingController _searchController = TextEditingController();

  //Define posicao inicial do mapa
  final LatLng _center = const LatLng(-19.9219262, -43.9482831);

  //Define controlador do mapa
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _showSnackBar({String value, Color color}) =>
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('$value'),
        backgroundColor: color,
      ));

  //Funcao de pesquisa de local
  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.check);
        _appBarTitle = TextField(
          controller: _searchController,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Procure um local...',
              hintStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
        );
      } else {
        _showSnackBar(value: 'Você procurou: ${_searchController.text}');
        _searchIcon = Icon(Icons.search);
        _appBarTitle = Text('Maps');
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            color: Colors.white,
            onPressed: _searchPressed,
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
      ),
    );
  }
}
