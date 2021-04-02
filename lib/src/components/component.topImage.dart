import 'package:flutter/material.dart';


/*
  Este componente recibe la ubicacion de la imagen, el titulo y el subtitulo que el programador decida enviarle.
  En caso de que no se envien los parametros que se requieren, se le asignan unos por defecto para evitar posibles errores.
*/
//ignore: must_be_immutable
class TopImageComponent extends StatefulWidget {
  String imageSource;
  String title;
  String subTitle;
  double height;
  TopImageComponent({
    this.imageSource = 'assets/ups.jpg',
    this.title = 'Ups! Algo salió mal',
    this.subTitle = 'Intentalo de nuevo',
    this.height = 320.0,
  });
  
  @override
  _TopImageComponentState createState() => _TopImageComponentState();
}

class _TopImageComponentState extends State<TopImageComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: widget.height,
          child: Image.asset(
            widget.imageSource, 
            fit: BoxFit.contain,
          )
        ),

        Text(widget.title, 
          overflow: TextOverflow.ellipsis, 
          style: TextStyle(
            fontSize: 30.0
          ),
        ),

        Text(widget.subTitle, 
          overflow: TextOverflow.ellipsis, 
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
      ],
    );
  }
}