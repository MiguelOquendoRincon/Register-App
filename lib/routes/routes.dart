import 'package:flutter/material.dart';
import 'package:register_application/src/views/view.login.dart';
import 'package:register_application/src/views/view.profile.dart';
import 'package:register_application/src/views/view.signUp.dart';

// Creamos una clase que tiene un mapa con las diferentes rutas que manejaremos dentro de la aplicación.
class Rutas {
  static Map<String, WidgetBuilder> getRutas() {
    return <String, WidgetBuilder>{
      'login'    : (BuildContext context) => LoginPage(),
      'signUp' : (BuildContext context) => SignUpPage(),
      'profile'   : (BuildContext context) => ProfilePage(),
    };
  }
}