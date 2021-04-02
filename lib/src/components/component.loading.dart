import 'package:flutter/material.dart';


/*Componente de carga por defecto, recibe dos parametros opcionales, el asset que determina la imagen que este componente usará
y su titulo. En caso de no recibirlos carga unos recursos predeterminados.*/
//ignore: must_be_immutable
class LoadingAlert extends StatefulWidget {

  String asset;
  String title;

  LoadingAlert({
    this.asset = 'assets/done.gif',
    this.title = 'Espera mientras procesamos tus datos',
  });

  @override
  _LoadingAlertState createState() => _LoadingAlertState();
}

class _LoadingAlertState extends State<LoadingAlert> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              Container(
                height: size.height * 0.14,
                child: Image(image: AssetImage(widget.asset)),
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                widget.title,
                style: TextStyle(color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        );
  }
}