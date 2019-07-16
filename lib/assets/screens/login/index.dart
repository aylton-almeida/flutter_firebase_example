import 'package:flutter/material.dart';
import '../../utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/globals.dart' as globals;

//Cria um widget que pode ter seu estado alterado apos compilacao
class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  //Retorna uma nova instancia do stado
  _LoginPageState createState() => new _LoginPageState();
}

//Estado da pagina de login
class _LoginPageState extends State<LoginPage> {
  //Variavel firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Declarar chave do form
  final _formKey = GlobalKey<FormState>();
  //Declarar chave do scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Variaveis para controle dos textField
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  //Button pressed
  _handleButtonPressed() async {
    if (_formKey.currentState.validate()) {
      _showSnackBar(value: "Processando", color: Colors.yellow[800]);
      bool _isLoggedIn = await _logIn();
      _isLoggedIn
          ? Navigator.of(context).pushNamed('/LogadoPage')
          : _showSnackBar(
              value: 'Email ou senha incorreto',
              color: Colors.red,
            );
    } else {
      _showSnackBar(
          value: "Preencha os campos corretamente", color: Colors.red);
    }
  }

  //handle login
  _logIn() async {
    bool _isLoggedIn = false;
    FirebaseUser _user;
    try {
      _user = await _auth.signInWithEmailAndPassword(
        email: _controladorEmail.text,
        password: _controladorSenha.text,
      );
    } catch (ignored) {}
    if (_user != null) {
      globals.loggedUser = {
        'email': _user.email,
        'code': _user.uid,
        'islogged': true,
      };
      _isLoggedIn = true;
    }

    return _isLoggedIn;
  }

  //Mostrar Snackbar
  _showSnackBar({String value, Color color}) =>
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('$value'),
        backgroundColor: color,
      ));

  //Função build do app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0),
                children: <Widget>[
                  //Imagem
                  Container(
                    height: 100,
                    child: Image.asset('images/dart_logo.png'),
                  ),
                  //Email field
                  Container(
                    height: 100,
                    child: TextFormField(
                      controller: _controladorEmail,
                      autocorrect: true,
                      autofocus: true,
                      //Validacao
                      validator: Validators.validateEmail,
                      //Placeholer, label e tipo
                      decoration: const InputDecoration(
                        hintText: 'Digite seu email',
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  //Password Field
                  Container(
                    height: 100,
                    child: TextFormField(
                      controller: _controladorSenha,
                      autocorrect: true,
                      autofocus: true,
                      //Validacao
                      validator: Validators.validatePassword,
                      //Placeholer, label e tipo
                      decoration: const InputDecoration(
                        hintText: 'Digite sua senha',
                        labelText: 'Senha',
                      ),
                      obscureText: true,
                    ),
                  ),
                  //Sumbit Button
                  Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 62),
                        child: RaisedButton(
                          onPressed: _handleButtonPressed,
                          child: Text(
                            'Concluir',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                      )),
                ],
              )),
        ));
  }
}
