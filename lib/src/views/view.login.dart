import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:register_application/src/components/component.loading.dart';
import 'package:register_application/src/components/component.showError.dart';

import 'package:register_application/src/components/component.topImage.dart';
import 'package:register_application/src/preferences/preferences.dart';
import 'package:register_application/src/providers/provider.data.dart';
import 'package:register_application/src/providers/provider.user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variable para guardar el tamaño de la pantalla del dispositivo en el que corre la app.
  var size;
  // Variable usada para separar widgets sin emplear el margin.
  var divHeight;
  // Variable que determina si la contraseña se oculta o no.
  bool _visiblePass = true;

  //Usado para cargar las preferencias.
  final prefs = new UserPreferences();

  //Usado para acceder a la clase DataProvider.
  final datos = DataProvider();

  //Usado para acceder a la clase UserProvider.
  final userProvider = new UserProvider();

  /*Variables usadas para guardar el correo y contraseña*/
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    divHeight = size.height * 0.03; 
    return FadeIn(
      duration: Duration(milliseconds: 2000),
      child: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          child: WillPopScope(
            onWillPop: _onBackPressed,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  width: size.width * 0.95,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: divHeight),
                      TopImageComponent(
                        imageSource: 'assets/loginImage.jpg',
                        title: '¡Bienvenido!',
                        subTitle: 'Inicia sesión para disfrutar de nuestra app',
                      ),
                      _inputs(context),
                      _buttons(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*Widget encargado de contener los inputs de email y password */
  Widget _inputs(BuildContext context){
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.3,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _email(context),
            SizedBox(height: divHeight* 1.5),
            _password(context),
          ],
        ),
      ),
    );
  }

  /*Widget encargado de contener el input del email */
  Widget _email(BuildContext context){
    return Container(
      height: 58,
      child: TextFormField(
        // autofocus: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Usuario',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.location_history),
        ),
        onChanged: (value) => setState(() => email = (value).trim()),
      ),
    );
  }


  /*Widget encargado de contener el input del password. Tiene una propiedad dinamica que le permite hacer o no visible la contraseña */
  Widget _password(BuildContext context){
    return Container(
      height: 58,
      child: TextFormField(
        obscureText: _visiblePass,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              _visiblePass? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() => _visiblePass =  !_visiblePass),
          )
        ),
        onChanged: (value) => setState(() => password = (value).trim()),
      ),
    );
  }


  /*Widget encargado de contener los buttons de iniciar sesion y registrarse */
  Widget _buttons(BuildContext context){
    return Container(
      width: size.width * 0.9,
      child: Column(
        children: [
          _logIn(context),
          SizedBox(height: divHeight),
          _signUp(context)
        ],
      ),
    );
  }

  /*Widget encargado de contener el button de iniciar sesion, este realiza validaciones de correo y contraseña, si todo está bien ejecuta el metodo para iniciar sesión*/
  Widget _logIn(BuildContext context){
    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Theme.of(context).primaryColor
      ),
      child: TextButton(
        child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
        onPressed: (){
          if(email == ''){
            _showError(context, 'El email no puede ser vacío');
          } else if (password == ''){
            _showError(context, 'La contraseña no puede ser vacía');
          } else if(!isEmail(email)) {
            _showError(context, 'Ingresa un email valido');
          } else {
            _postSignIn(email, password);
          }
        },
      ),
    );
  }


  /*Al usar la api que nos proporsiona FireBase creamos una Base de Datos en la cual guardamos la información de cada usuario.
  Sin embargo, no controlamos el id con el que registramos un usuario nuevo. Es por esto que en este metodo pido la información
  de todos los usuarios registrados, itero sobre cada registro buscando si existe el email ingresado por el usuario. En caso de 
  ser así, almaceno esa información en las preferencias del usuario, de esta manera no debo volver a realizar iteraciones cada vez
  que desee conocer algun dato del usuario registrado.*/
  _postSignIn(String email, String password) async{
    try {
      _loading();
      Map info2 = await datos.getInfoProfile();
      Map userBD;
      String userPass = '';
      info2.forEach((key, value) { 
        if(value["email"] == email){ 
          userBD = value; 
          prefs.userId = key;
          userPass = datos.desencripted(value["password"]);
        }
      });

      if(userBD == null){
        Navigator.pop(context);
        _showError(context, 'Ups! Al parecer no existe tu usuario. Regístrate, es gratis.');
      } else if(userPass == password){
        Navigator.pop(context);
        prefs.name = userBD["name"];
        prefs.lastName = userBD["lastName"];
        prefs.email = userBD["email"];
        prefs.password = userBD["password"];
        prefs.birthdayDate = userBD["birthdayDate"];
        prefs.directions = json.encode(userBD["directions"] == null ? [] : userBD["directions"]);
        Navigator.pushNamedAndRemoveUntil(context, 'profile', (Route<dynamic> route) => false); 
      } else {
        Navigator.pop(context);
        _showError(context, 'Ups! Contraseña incorrecta');
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      _showError(context, 'Ups! Algo salió mal, verifica tus datos');
    }
  }


  /*Envuelve el button de registrarse. Al presionarlo nos muestra distintas maneras de registrar. */
  Widget _signUp(BuildContext context){
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(bottom: 30.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
          color:  Theme.of(context).secondaryHeaderColor,
        ),
      ),
      child: TextButton(
        child: Text('Registrarme', style: TextStyle(fontSize: 15.0), overflow: TextOverflow.ellipsis,),
        onPressed: (){
          _showRegisterAlert(context);
        },
      ),
    );
  }


  /*Alerta que envuelve las distintas maneras de registrar. */
  Future<bool> _showRegisterAlert(BuildContext context){
    return showDialog(
      context: context, 
      builder: (context){
        return SlideInUp(
          duration: Duration(milliseconds: 800),
          child: AlertDialog(
            title: Text('Selecciona cómo quieres registrarte', textAlign: TextAlign.center,),
            content: Container(
              alignment: Alignment.center,
              height: 300,
              child: Column(
                children: [
                  SizedBox(height: divHeight* 1.5),
                  Container(
                    width: size.width * 0.9,
                    margin: EdgeInsets.only(bottom: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Color(0xFFF576EA5)
                    ),
                    child: IconButton(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/facebook.png'),
                          SizedBox(width: 20),
                          Text('Facebook', style: TextStyle(fontSize: 15.0, color: Colors.white), overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      onPressed: (){
                        _showNearUpdate(context);
                      },
                    ),
                  ),

                  Container(
                    width: size.width * 0.9,
                    margin: EdgeInsets.only(bottom: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color:  Theme.of(context).primaryColor,
                      ),
                    ),
                    child: IconButton(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/gmail.jpg'),
                          SizedBox(width: 20),
                          Text('Google', style: TextStyle(fontSize: 15.0), overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      onPressed: (){
                        _showNearUpdate(context);
                      },
                    ),
                  ),

                  Container(
                    width: size.width * 0.9,
                    margin: EdgeInsets.only(bottom: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color:  Theme.of(context).secondaryHeaderColor,
                    ),
                    child: IconButton(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.white,),
                          SizedBox(width: 20),
                          Text('Email', style: TextStyle(fontSize: 15.0, color: Colors.white), overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'signUp');
                      },
                    ),
                  ),
                ],
              ),
            )
          ),
        );
    });
  }

  /*Alerta que se muestra en caso de presionar Facebook o Gmail*/
  Future<bool> _showNearUpdate(BuildContext context){
    return showDialog(
      context: context, 
      builder: (context){
        return FadeIn(
          duration: Duration(milliseconds: 800),
          child: AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/ups.jpg'),
                Text('¡Lo sentimos! Esta caracteristica estará disponible pronto', textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 4,),
              ],
            ),
            content: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextButton(
                child: Text('Entendido', style: TextStyle(color: Colors.white),),
                onPressed: () => Navigator.pop(context),
              ),
            )

          ),
        );
    });
  }

  /*Valida si el email cumple con los standars.*/
  bool isEmail(String emailTest) {
    /*Variable para determinar si el correo es valido*/
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(emailTest);
    return emailValid;
  } 


  /*Alerta que usa el componente ErrorAlert para mostrar un error al usuario */
  Future<bool> _showError(BuildContext context, String message){
    return showDialog(
      context: context, 
      builder: (BuildContext contex) => ErrorAlert(message: message,)
    );
  }

  /*Alerta que usa el componente LoadingAlert para mostrar un proceso de carga al usuario*/
  Future<bool> _loading() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingAlert(
        asset: 'assets/ups.jpg',
      )
    );
  }

  /*Alerta que pregunta si el usuario desea salir de la aplicación cuando no hay una pantalla a la cual regresar*/
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              Container(
                height: size.height * 0.2,
                width: double.infinity,
                child: Image.asset('assets/exitAlert.jpg', fit: BoxFit.fill,),
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                '¿Quieres salir de la aplicación?',
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12.0)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  width: size.width * 0.16,
                  child: Text('No', style: TextStyle(color: Colors.white)),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12.0)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: size.height * 0.06,
                  width: size.width * 0.16,
                  child: Text('Si', style: TextStyle(color: Colors.white)),
                ),
                onPressed: () => exit(0),
              ),
            ],
          ),
        );
      }
    );
  }
}