import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogadoPage extends StatefulWidget {
  const LogadoPage({Key key}) : super(key: key);

  @override
  _LogadoPageState createState() => _LogadoPageState();
}

class _LogadoPageState extends State<LogadoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Mostrar Snackbar
  _showSnackBar({String value, Color color}) =>
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('$value'),
        backgroundColor: color,
      ));

  //Função de construcao do corpo da pagina, recuperando usuarios do banco
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pessoas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                  child: Text('Carregando conteudo'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120),
                  child: LinearProgressIndicator(),
                )
              ],
            )),
          );
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  //Funcao para gerar lista de componentes da pagina
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListitem(context, data)).toList(),
    );
  }

  //Gerar itens da lista
  Widget _buildListitem(BuildContext context, DocumentSnapshot snapshot) {
    final dynamic nome = snapshot.data['nome'];
    final dynamic idade = snapshot.data['idade'].toString();
    final dynamic sexo = snapshot.data['sexo'];

    return Padding(
      key: ValueKey(nome),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(nome),
          subtitle: Text(sexo),
          trailing: Text(idade),
          onTap: () => Firestore.instance.runTransaction((transaction) async {
            final freshSnapshot = await transaction.get(snapshot.reference);
            final novaIdade = freshSnapshot.data['idade'];

            await transaction
                .update(snapshot.reference, {'idade': novaIdade + 1});
          }),
        ),
      ),
    );
  }

  Future _mostraUsuario() async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user == null)
      return 'Carregando usuario';
    else
      return _user.email;
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
        title: FutureBuilder(
          future: _mostraUsuario(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Text(snapshot.data);
          },
        ),
      ),
      body: Center(
        child: _buildBody(context),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.near_me,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pushNamed('/MapsPage'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Icon(Icons.ac_unit, color: Colors.white),
            ),
          ],
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
