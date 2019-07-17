import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoder/geocoder.dart';

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

  //Set de marcador
  final Set<Marker> _markers = <Marker>{
    Marker(
        markerId: MarkerId('Escritorio'),
        position: LatLng(-19.9219262, -43.9482831)),
  };

  //Codifica endereco
  void _codeAdress() async {
    List<Address> addresses =
        await Geocoder.google(DotEnv().env['GOOGLE_MAPS_API'])
            .findAddressesFromQuery('1600 Amphiteatre Parkway, Mountain View');
    var first = addresses.first;
    Coordinates _coo = first.coordinates;
    LatLng _newPosition = LatLng(_coo.latitude, _coo.longitude);
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(first.locality),
      position: _newPosition,
    ));
  }

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
          autofocus: true,
        );
      } else {
        _showSnackBar(value: 'Você procurou: ${_searchController.text}');
        //Retirar foco do input
        FocusScope.of(context).requestFocus(FocusNode());
        _codeAdress();
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
        initialCameraPosition: CameraPosition(target: _center, zoom: 16.0),
        markers: _markers,
      ),
    );
  }
}
