import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:register_application/src/components/component.directionAlert.dart';
import 'package:register_application/src/components/component.loading.dart';
import 'package:register_application/src/components/component.showError.dart';

import 'package:register_application/src/components/component.topImage.dart';
import 'package:register_application/src/preferences/preferences.dart';
import 'package:register_application/src/providers/provider.data.dart';
import 'package:register_application/src/providers/provider.user.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
    // Variable para guardar el tamaño de la pantalla del dispositivo en el que corre la app.
  var size;
  // Variable usada para separar widgets sin emplear el margin.
  var divHeight;
  // Lista dedicada a guardar todas las posibles direcciones que el usuario agregre.
  final List directions = [];

  //Variables dedicadas a guardar el nombre, apellido y fecha de nacimiento del usuarioa.
  String name = '';
  String lastName = '';
  String date = 'null';
  String email = '';
  String password = '';

  // Variable que determina si la contraseña se oculta o no.
  bool _visiblePass = true;

  //Usado para acceder a la clase DataProvider.
  final data = new DataProvider();

  //Usado para acceder a la clase UserProvider.
  final userProvider = new UserProvider();

  //Usado para cargar las preferencias.
  final prefs = new UserPreferences();


  //Variable dedicada a guardar la dirección ingresada por el usuario en formato string.
  String directionValue;
  //Variables dedicadas a guardar el tipo de vía del usuario, numero de vía, cruce y numero de casa.
  String streetType;
  String streetNumber;
  String streetCross;
  String houseNumber;
  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    divHeight = size.height * 0.03;
    directionValue = '';
    streetNumber = '';
    streetCross = '';
    houseNumber = '';

    return FadeIn(
      duration: Duration(milliseconds: 2000),
      child: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: size.width * 0.95,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TopImageComponent(
                      imageSource: 'assets/registerImage.jpg',
                      title: '¡Registrate!',
                      subTitle: 'Es gratis y lo seguirá siendo',
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
    );
  }


  /*Widget que contiene el formulario de registro*/
  Widget _inputs(BuildContext context){
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(top: 30.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _name(context),
            SizedBox(height: divHeight* 1.5),
            _lastName(context),
            SizedBox(height: divHeight* 1.5),
            _birthdayDate(context),
            SizedBox(height: divHeight* 1.5),
            _email(context),
            SizedBox(height: divHeight* 1.5),
            _password(context),
            SizedBox(height: divHeight* 1.5),
            directions.length == 0 ? Container() : _listDirection(context),
            _direction(context),
            SizedBox(height: divHeight* 1.5),
          ],
        ),
      ),
    );
  }


  /*Input que guarda el nombre del usuario*/
  Widget _name(BuildContext context){
    return Container(
      height: 58,
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Nombres*',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.location_history),
        ),
        onChanged: (value) => setState(() => name = (value)),
      ),
    );
  }


  /*Input que guarda el apellido del usuario*/
  Widget _lastName(BuildContext context){
    return Container(
      height: 58,
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Apellidos*',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.location_history),
        ),
        onChanged: (value) => setState(() => lastName = (value)),
      ),
    );
  }


  /*Input que guarda la fecha de nacimiento del usuario*/
  Widget _birthdayDate(BuildContext context){
    return Container(
      child: InkWell(
        onTap: () {
          showDatePicker(
            context: context, 
            initialDate: DateTime.now(), 
            firstDate: DateTime(1930), 
            lastDate: DateTime.now(), //Esto evita que las personas ingresen fechas posteriores al día actual.
          ).then((date1) {
            List listDate = date1.toString().split(' ');
            setState(() => date = listDate[0]);
          });
        },
        child: Container(
          width: size.width * 0.90,
          height: 58,
          child: InputDecorator(
            child: date == "null" ? Text('YYYY/MM/DD') :Text(date),
            expands: true,
            decoration: InputDecoration(
              labelText: 'Fecha de nacimiento *', 
              enabled: true,
              prefixIcon: Icon(Icons.calendar_today_outlined),
              suffixIcon: Icon(Icons.arrow_drop_down),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
              )
            ),
          ),
        ),
      ),
    );
  }


  /*Input que guarda el email del usuario*/
  Widget _email(BuildContext context){
    return Container(
      height: 82,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email*',
          helperText: 'Con este email accederás a nuestra app.',
          helperMaxLines: 3,
          helperStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.location_history),
        ),
        onChanged: (value) => setState(() => email = (value).trim()),
      ),
    );
  }


  /*Input que guarda la constraseña del usuario, tiene un metodo que permite hacer o no visible la contraseña*/
  Widget _password(BuildContext context){
    return Container(
      height: 58,
      child: TextFormField(
        obscureText: _visiblePass,
        decoration: InputDecoration(
          hintText: 'Contraseña*',
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


  /*Lista que muestra las direcciones del usuario, en caso de no tener se oculta*/
  Widget _listDirection(BuildContext context){
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return directions.length == 0 ? Container() : FadeOut(
          duration: Duration(milliseconds: 1000),
          child: Column(
            children: [
              Text('Mis direcciones', style: TextStyle(fontSize: 18.0)),
              Container(
                width: size.width * 0.9,
                height: 250,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5),),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(-1, 3), 
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: directions.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      width: size.width * 0.9,
                      height: 58.0,
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Theme.of(context).backgroundColor)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${directions[index]}', style: TextStyle(color: Colors.black, fontSize: 15.0), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => setState(() => directions.remove('${directions[index]}')),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height: divHeight* 1.5),
            ],
          ),
        );
      }
    );
  }


  /*Button que agrega una nueva dirección*/
  Widget _direction(BuildContext context){
    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Theme.of(context).backgroundColor)
      ),
      child: IconButton(
        autofocus: true,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 20),
            Text('Agregar dirección*', style: TextStyle(color: Colors.black, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
          ],
        ),
        onPressed: () => _directionPage(context),
      ),
    );
  }


  /*Alert que usa el DirectionComponent para obtener una direccion en formato string y agregarla a la lista en caso que pase las validaciones*/
  Future<bool> _directionPage(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return DirectionComponent();
      },
    ).then((value) {
      FocusScope.of(context).requestFocus(new FocusNode());
      if(value != null){
        /*
        Preguntamos si la lista es vacia, de lo contrario la recorremos para encontrar si existe un valor igual al ingresado. En caso de ser 
        así, mostramos una alerta. Tambien validamos que los campos tengan valores antes de ingresarlos a la lista.
        */
        if(directions.length == 0 ){
          if(value == ''){
            _showError(context, 'Todos los campos son obligatorios');
          } else {
              directions.add(value);
          } 
        }else {
          bool error = false;
          directions.forEach((direction) { 
            if(direction == value){
              error = true;
              _showError(context, 'Ups! Al parecer ya existe una dirección igual.');
              //  Navigator.pop(context);
            }
          });

          if(error){
            setState((){
              value = value;
            });
          } else {
            if(value == ''){
              _showError(context, 'Todos los campos son obligatorios');
            } else {
              setState(() {
                directions.add(value);
                // Scaffold.of(context).build(context);
              });
            } 
          }
        }
      }
      
    });
  }


  /*Encargado de envolver los botones inferiores*/
  Widget _buttons(BuildContext context){
    return Container(
      width: size.width * 0.9,
      child: Column(
        children: [
          _signUp(context),
          SizedBox(height: divHeight),
          _logIn(context),
        ],
      ),
    );
  }


  /*Widget que valida si el usuario ingreso la información requerida y de manera correcta, si es así ejecuta el metodo para registrarlo en la BD*/
  Widget _signUp(BuildContext context){
    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Theme.of(context).primaryColor
      ),
      child: TextButton(
        child: Text('Registrarme', style: TextStyle(color: Colors.white, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
        onPressed: (){
          if(email == '' || password == '' || date == 'null' || name == '' || lastName == ''){
            _showError(context, 'Todos los campos son obligatorios');
          } else if(!isEmail(email)) {
            _showError(context, 'Ingresa un email valido');
          } else {
            _postSignUp();
          }
        },
      ),
    );
  }


  /*Al usar la api que nos proporsiona FireBase creamos una Base de Datos en la cual guardamos la información de cada usuario.
  Sin embargo, no controlamos el id con el que registramos un usuario nuevo. Es por esto que en este metodo pido la información
  de todos los usuarios registrados, itero sobre cada registro buscando si existe el email ingresado por el usuario. En caso de 
  ser así, muestro una alerta informando que ya existe un usuario con dicho email.*/
  _postSignUp() async{
    try {
      if(name == '' || lastName == '' || email == '' || password == '' || date == 'null' || directions.length == 0){
        _showError(context, 'Todos los campos son obligatorios');
      } else {
        _loading('assets/ups.jpg', 'Espera mientras te agregamos a nuestra hermosa comunidad');
        Map info2 = await data.getInfoProfile();
        bool userCreated = false;
        info2.forEach((key, value) { 
          if(value["email"] == email){ userCreated = true; }
        });

        if(userCreated){
          Navigator.pop(context);
          _showError(context, 'Ups! Al parecer ya existe un usuario con este correo.');
        } else {
          Map info = await userProvider.signUp(email, password, name, lastName, date, directions);
          prefs.userId = info['userId'];
          prefs.name = name;
          prefs.lastName = lastName;
          prefs.email = email;
          prefs.birthdayDate = date;
          prefs.directions = json.encode(directions);

          Navigator.pop(context);
          _loading('assets/done.gif', '¡Bienvenido a nuestra comunidad!');
          await Future.delayed(Duration(milliseconds: 3000), () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, 'profile', (Route<dynamic> route) => false); 
          });
        }
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      _showError(context, 'Ups! Algo salió mal. Intentalo de nuevo');
    }
  }


  /*Button que regresa a la pagina de login*/
  Widget _logIn(BuildContext context){
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
        child: Text('Ya tengo una cuenta', style: TextStyle(fontSize: 15.0), overflow: TextOverflow.ellipsis,),
        onPressed: () => Navigator.pop(context)
      ),
    );
  }


  /*Alerta que usa el componente ErrorAlert para mostrar un error al usuario */
  Future<bool> _showError(BuildContext context, String message){
    return showDialog(
      context: context, 
      builder: (BuildContext contex) =>ErrorAlert(message: message,)
    );
  }


/*Valida si el email cumple con los standars.*/
  bool isEmail(String emailTest) {
    /*Variable para determinar si el correo es valido*/
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(emailTest);
    return emailValid;
  }


  /*Alerta que usa el componente LoadingAlert para mostrar un proceso de carga al usuario*/
  Future<bool> _loading(String asset, String title) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingAlert(
        asset: asset,
        title: title,
      ),
    );
  }

}

