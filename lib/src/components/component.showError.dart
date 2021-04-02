import 'package:flutter/material.dart';


/*Componente de error por defecto, recibe el parametro mensaje. Si no recibe asigna un valor por defecto*/

//ignore: must_be_immutable
class ErrorAlert extends StatefulWidget {

  String message;

  ErrorAlert({
    this.message = 'Ups! Algo salió mal'
  });
  @override
  _ErrorAlertState createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
          title: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/ups.jpg'),
                  Text(widget.message, textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 7,),
                ],
              ),
          ),
          content: Container(
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Theme.of(context).primaryColor
            ),
            child: TextButton(
              child: Text('Entiendo', style: TextStyle(color: Colors.white, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
              onPressed: () {
                Navigator.pop(context);
              } 
            ),
          ),
        );
  }
}