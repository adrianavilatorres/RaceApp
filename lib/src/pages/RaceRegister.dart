import 'package:app_races/src/models/RacesViewModel.dart';
import 'package:app_races/src/models/UserCredentials.dart';
import 'package:app_races/src/pages/RaceLogin.dart';
import 'package:app_races/src/responses/RegisterResponse.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

class RaceRegister extends StatefulWidget {
  static final String route = '/RaceRegister';
  RaceRegister({Key key}) : super(key: key);

  @override
  _RacesRegisterState createState() => _RacesRegisterState();
}

class _RacesRegisterState extends State<RaceRegister> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _error = false;
  UserCredentials _credentials = UserCredentials();
  RegisterResponse registerResponse =
      RegisterResponse.unknowError('Error desconocido');

  String _emailValidator(String email) {
    final emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      return 'El email insertado no es valido';
    }
  }

  String _passwordValidator(String password) {
    if (password.length < 3) {
      return 'La constraseña no puede tener menos de 3 caracteres';
    }
  }

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      registerResponse =
          await ScopedModel.of<RaceViewModel>(context, rebuildOnChange: true)
              .register(_credentials);

      if (registerResponse.status == RegisterResponseStatus.Success) {
        Navigator.pushNamedAndRemoveUntil(
            context, RaceLogin.route, (route) => false);
      } else {
        setState(() {
          _error = true;
        });
      }
    }
  }

  _onChangeField(String value) {
    setState(() {
      _error = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        buildBackgroundTopCircle(),
        buildBackgroundBottomCircle(),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            margin: EdgeInsets.all(5),
                            elevation: 10,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Image.asset(
                                        'assets/img/logo.png',
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.email,
                                      color: Colors.blue,
                                    ),
                                    title: TextFormField(
                                      initialValue: "sam@gmai.com",
                                      onChanged: _onChangeField,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onSaved: (newValue) =>
                                          _credentials.email = newValue.trim(),
                                      decoration: InputDecoration(
                                        hintText: 'Correo electronico',
                                      ),
                                      validator: _emailValidator,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.security,
                                      color: Colors.blue,
                                    ),
                                    title: TextFormField(
                                      initialValue: "123",
                                      onSaved: (newValue) => _credentials
                                          .password = newValue.trim(),
                                      validator: _passwordValidator,
                                      obscureText: !_showPassword,
                                      onChanged: _onChangeField,
                                      decoration: InputDecoration(
                                          hintText: 'Contraseña',
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                _showPassword
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword =
                                                      !_showPassword;
                                                });
                                              })),
                                    ),
                                  ),
                                  if (_error)
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        registerResponse.errorMessage,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ),
                                ]),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [_buildLoginButton()],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [_buildLoginButton2()],
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Positioned buildBackgroundTopCircle() {
    return Positioned(
      top: 0,
      child: Transform.translate(
        offset: Offset(0.0, -MediaQuery.of(context).size.width / 1.3),
        child: Transform.scale(
          scale: 1.35,
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width,
                )),
          ),
        ),
      ),
    );
  }

  Positioned buildBackgroundBottomCircle() {
    return Positioned(
      top: MediaQuery.of(context).size.height -
          MediaQuery.of(context).size.width,
      right: MediaQuery.of(context).size.width / 2,
      child: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            )),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 8),
          margin: EdgeInsets.only(bottom: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: _login,
            child: Text(
              "Registrar",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoginButton2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              Navigator.pushNamed(context, RaceLogin.route);
            },
            child: Text(
              "Volver",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }
}
