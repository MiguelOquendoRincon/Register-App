
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:register_application/src/components/component.directionAlert.dart';
import 'package:register_application/src/components/component.loading.dart';
import 'package:register_application/src/components/component.showError.dart';
import 'package:register_application/src/components/component.topImage.dart';
import 'package:register_application/src/preferences/preferences.dart';
import 'package:register_application/src/providers/provider.user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // Variable para guardar el tamaño de la pantalla del dispositivo en el que corre la app.
  var size;
  // Variable usada para separar widgets sin emplear el margin.
  var divHeight;

  // Lista dedicada a guardar todas las posibles direcciones que el usuario agregre.
  List directions = [];

  //Variables dedicadas a guardar el nombre, apellido y fecha de nacimiento del usuarioa.
  String userId = '';
  String name = '';
  String lastName = '';
  String date = 'null';
  int year;
  int month;
  int day;
  String email = '';
  String password = '';

  //Usado para cargar las preferencias.
  final prefs = new UserPreferences();

  //Usado para acceder a la clase UserProvider.
  final userProvider = new UserProvider();


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
    /*Basicamente guardamos en nuestras variables locales la información del usuario, sin embargo realizamos validaciones para evitar que se sobreescriban las variables
    al hacer un setState */
    userId = userId == '' ? prefs.userId : userId;
    name = name == '' ? prefs.name : name;
    lastName = lastName == '' ? prefs.lastName : lastName;
    date = date == 'null' ? prefs.birthdayDate : date;
    email = email == '' ? prefs.email : email;
    password = password == '' ? prefs.password : password;
    directions = directions.length == 0 ? json.decode(prefs.directions) : directions;
    year = int.parse(date.split('-')[0]);
    month = int.parse(date.split('-')[1]);
    day = int.parse(date.split('-')[2]);
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
                        imageSource: 'assets/profile.jpg',
                        title: '¡Bienvenido!',
                        subTitle: 'Es un placer verte $name $lastName',
                        height: 250,
                      ),
                      _personalData(context),
                      _buttons(context),
                      SizedBox(height: divHeight),
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
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false),
              ),
            ],
          ),
        );
      }
    );
  }


  /*Este widget envuelve todos los campos de información del perfil*/
  Widget _personalData(BuildContext context){
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(top: 30.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nombres'),
            SizedBox(height: divHeight * 0.5),
            _name(context),
            Text('Apellidos'),
            SizedBox(height: divHeight * 0.5),
            _lastName(context),
            Text('Usuario'),
            SizedBox(height: divHeight * 0.5),
            _email(context),
            Text('Fecha Nacimiento'),
            SizedBox(height: divHeight * 0.5),
            _birthdayDate(context),
            SizedBox(height: divHeight),
            _listDirection(context),
            SizedBox(height: divHeight),
            _direction(context),
            SizedBox(height: divHeight),
          ],
        ),
      ),
    );
  }


  /*Este widget envuelve el input que tiene como valor inicial el nombre registrado por el usuario pero puede ser modificado para posteriormente ser actualizado*/
  Widget _name(BuildContext context){
    return Container(
      height: 100,
      child: TextFormField(
        // autofocus: true,
        initialValue: name,
        decoration: InputDecoration(
          hintText: 'Nombre',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.location_history),
        ),
        onChanged: (value){
          if(value== ''){
            _showError(context, 'No puedes eliminar tu nombre');
          }else{
            setState(() => name = (value));
          }
        },
      ),
    );
  }


  /*Este widget envuelve el input que tiene como valor inicial el apellido registrado por el usuario pero puede ser modificado para posteriormente ser actualizado*/
  Widget _lastName(BuildContext context){
    return Container(
      height: 100,
      child: TextFormField(
        // autofocus: true,
        initialValue: lastName,
        decoration: InputDecoration(
          hintText: 'Apellido',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.location_history),
        ),
        onChanged: (value){
          if(value== ''){
            _showError(context, 'No puedes eliminar tu Apellido');
          }else{
            setState(() => lastName = (value));
          }
        },
      ),
    );
  }


  /*Este widget envuelve el input que tiene como valor inicial el email registrado por el usuario pero puede ser modificado para posteriormente ser actualizado*/
  Widget _email(BuildContext context){
    return Container(
      height: 100,
      child: TextFormField(
        initialValue: email,
        decoration: InputDecoration(
          hintText: 'Nombre',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),),
          prefixIcon: Icon(Icons.location_history),
        ),
        onChanged: (value){
          if(value== ''){
            _showError(context, 'No puedes eliminar tu email');
          }else{
            setState(() => email = (value));
          }
        },
      ),
    );
  }


  /*Este widget envuelve el "input" que tiene como valor inicial la fecha de nacimiento registrada por el usuario pero puede ser modificado para posteriormente ser actualizado*/
  Widget _birthdayDate(BuildContext context){
    return Container(
      child: InkWell(
        onTap: () {
          showDatePicker(
            context: context, 
            initialDate: DateTime(year, month, day), //BUSCAMOS LA FECHA EXACTA GUARDADA EN LA BD
            firstDate: DateTime(1930), 
            lastDate: DateTime.now(), //Esto evita que las personas ingresen fechas posteriores al día actual.
          ).then((date1) {
            List listDate = date1.toString().split(' ');
            setState(() {
              date = listDate[0];
            });
          });
        },
        child: Container(
          width: size.width * 0.90,
          height: 58,
          child: InputDecorator(
            child: date == "null" ? Text('YYYY/MM/DD') : Text(date),
            expands: true,
            decoration: InputDecoration(
              labelText: 'Fecha de nacimiento', 
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


  /*Este widget envuelve la lista que tiene como valor inicial las direcciones registradas por el usuario pero pueden ser modificads para posteriormente ser actualizadas*/
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
                            onPressed: () => setState((){
                              directions.remove('${directions[index]}');
                              prefs.directions = json.encode(directions);
                            }),
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


  /*Button que permite agregar una nueva direccion*/
  Widget _direction(BuildContext context){
    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Theme.of(context).backgroundColor)
      ),
      child: IconButton(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 20),
            Text('Agregar dirección', style: TextStyle(color: Colors.black, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
          ],
        ),
        onPressed: () => _directionPage(context),
      ),
    );
  }


  /*Alerta que usa el componente DirectionComponent para obtener una nueva direccion en formato string y agregarla a la lista. Se realizan validaciones para evitar agregar
  valores duplicados o en blanco.*/
  Future<bool> _directionPage(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return DirectionComponent();
      },
    ).then((value){
      if(value != null){
        /*
        Preguntamos si la lista es vacia, de lo contrario la recorremos para encontrar si existe un valor igual al ingresado. En caso de ser 
        así, mostramos una alerta. Tambien validamos que los campos tengan valores antes de ingresarlos a la lista.
        */
        if(directions.length == 0 ){
          if(value == ''){
            _showError(context, 'Todos los campos son obligatorios');
          } else {
              setState(() {
                directions.add(value);
              });
          } 
        }else {
          bool error = false;
          directions.forEach((direction) { 
            if(direction == value){
              error = true;
              _showError(context, 'Ups! Al parecer ya existe una dirección igual. Intenta de nuevo. Recuerda llenar nuevamente los campos');
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
              });
            } 
          }
        }
      }
      
    });
  }


  /*Widget que envuelve los buttons que permiten actualizar y cerrar sesión*/
  Widget _buttons(BuildContext context){
    return Container(
      width: size.width * 0.9,
      child: Column(
        children: [
          _updateInfo(context),
          SizedBox(height: divHeight),
          _signOut(context)
        ],
      ),
    );
  }


  /*Widget que permite actualizar los datos del usuario. En caso de no existir modificaciones no realiza ningun proceso y le muestra al usuario una alerta informandole.
  Cuando se eliminan datos de los inputs, la información que se envia al actualizar es la que tenía el usuario guardada, no permite
  atualizar si se ingresa un correo no valido*/
  Widget _updateInfo(BuildContext context){
    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Theme.of(context).secondaryHeaderColor
      ),
      child: TextButton(
        child: Text('Actualizar', style: TextStyle(color: Colors.white, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
        onPressed: () async{
          var prevDirections = json.decode(prefs.directions);
          try{
            if(!isEmail(email)){
              _showError(context, 'Ingresa un email valido');
            } else if(directions.length == 0 ){
              _showError(context, 'No puedes borrar todas tus direcciones');
            } else if(email == prefs.email && name == prefs.name && lastName == prefs.lastName && date == prefs.birthdayDate && directions.toString() == prevDirections.toString()){
              _showError(context, 'No has cambiado ningún dato. No hay nada por actualizar');
            } else{
              _loading('assets/ups.jpg', 'Espera mientras actualizamos tus datos');
              Map info = await userProvider.updateInfo(userId, email, password, name, lastName, date, directions);
              if(info['status']){
                Navigator.pop(context);
                _loading('assets/done.gif', '¡Bien! Tus datos han sido actualizados con éxito');
                await Future.delayed(Duration(milliseconds: 3000), () => Navigator.pop(context));
                setState(() {
                  prefs.email = email;
                  prefs.name = name;
                  prefs.lastName = lastName;
                  prefs.birthdayDate = date;
                  prefs.directions = json.encode(directions);
                });
              }
            }
          }catch(e){}
        },
      ),
    );
  }


  /*Cierra sesión enviando al usuario a la pagina de inicio y borrando sus datos de las preferencias */
  Widget _signOut(BuildContext context){
    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Theme.of(context).primaryColor
      ),
      child: TextButton(
        child: Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
        onPressed: (){
          //Elimina los datos guardados en las preferencias
          prefs.userId = '';
          prefs.name = '';
          prefs.lastName = '';
          prefs.email = '';
          prefs.birthdayDate = '';
          prefs.directions = json.encode([]);
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);   
        },
      ),
    );
  }


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
  Future<bool> _loading(String asset, String title) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingAlert(
        asset: asset,
        title: title,
      )
    );
  }

}
