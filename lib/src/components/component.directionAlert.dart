import 'package:flutter/material.dart';

class DirectionComponent extends StatefulWidget {
  @override
  _DirectionComponentState createState() => _DirectionComponentState();
}

/*Componente dedicado a la creación de una dirección. Retonar un string en formato "Calle 45 # 24 - 34"*/
class _DirectionComponentState extends State<DirectionComponent> {
  @override
  Widget build(BuildContext context) {
    return _directionPage(context);
  }

  //Variable dedicada a guardar la dirección ingresada por el usuario en formato string.
  String directionValue;
  //Variables dedicadas a guardar el tipo de vía del usuario, numero de vía, cruce y numero de casa.
  String streetType = 'Selecciona...';
  String streetNumber = '';
  String streetCross = '';
  String houseNumber = '';

  _directionPage(BuildContext context){
    final size = MediaQuery.of(context).size;
    return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  Container(
                    child: Text(
                      'Configura tu dirección exacta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(28, 39, 58, 1,),
                        fontWeight: FontWeight.w300
                      )
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    child: Text(
                      'Calle 10 # 24 -45',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0
                      )
                    ),
                  ),
                ],
              ),

              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Tipo de Vía', style: TextStyle(fontSize: 16.0)),
                    Container(
                      width: size.width * 0.9,
                      child: DropdownButton(
                        value: streetType,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward, color: Theme.of(context).primaryColor),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (value) => setState(() => streetType = (value).trim()),
                        items: ['Selecciona...', 'Carrera', 'Calle', 'Diagonal', 'Bulevar'].map<DropdownMenuItem>(( value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),


                    Text('Número Vía', style: TextStyle(fontSize: 16.0)),
                    Container(
                      height: 58,
                      child: TextFormField(
                        initialValue: streetNumber,
                        decoration: InputDecoration(
                          prefixText: ' N°',
                          hintText: '10',
                          border: UnderlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() => streetNumber = (value).trim()),
                      ),
                    ),


                    Text('Número', style: TextStyle(fontSize: 16.0)),
                    Container(
                      height: 58,
                      child: TextFormField(
                        initialValue: streetCross,
                        decoration: InputDecoration(
                          prefixText: ' #',
                          hintText: '24',
                          border: UnderlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() => streetCross = (value).trim()),
                      ),
                    ),
                    Container(
                      height: 58,
                      child: TextFormField(
                        initialValue: houseNumber,
                        decoration: InputDecoration(
                          prefixText: ' -',
                          hintText: '45',
                          border: UnderlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() => houseNumber = (value).trim()),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Theme.of(context).primaryColor
                          ),
                          child: TextButton(
                            child: Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
                            onPressed: (){
                              if(streetType == 'Selecciona...' || streetNumber == '' || streetCross == '' || houseNumber == ''){
                                directionValue = '';
                              } else {
                                directionValue = streetType + ' ' + streetNumber + ' # ' + streetCross + ' - ' + houseNumber;
                              }
                              setState(() { 
                                streetType = 'Selecciona...';
                                streetNumber = '';
                                streetCross = '';
                                houseNumber = '';
                              });
                              Navigator.pop(context, directionValue);
                            },
                          ),
                        ),

                        Container(
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Theme.of(context).secondaryHeaderColor
                          ),
                          child: TextButton(
                            child: Text('Cancelar', style: TextStyle(color: Colors.white, fontSize: 15.0), overflow: TextOverflow.ellipsis,),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
  }
}