import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:register_application/src/utils/crypto.AES.dart';


// Las peticiones POST y PUT de esta clase reciben como parametro el endpoint que se debe anexar a la url para realizar la consulta o modificación con éxito.
class DataProvider {

  final encriptar = Encriptacion();
  String datoEncrip;

  static String _url = 'https://registerapp-1c973-default-rtdb.firebaseio.com/';
  static String key = 'Esta_es_la_semilla_de_la_infO';
  
  /*
    ########         ########   #######   ######  ######## 
    ##     ##        ##     ## ##     ## ##    ##    ##    
    ##     ##        ##     ## ##     ## ##          ##    
    ########         ########  ##     ##  ######     ##    
    ##               ##        ##     ##       ##    ##    
    ##        ###    ##        ##     ## ##    ##    ##    
    ##        ###    ##         #######   ######     ## 
  */
  /*Peticion encargada de agregar el perfil del usuario a la base de datos.*/
  Future<Map<String, dynamic>> postPeticion(String endpoint, body) async {
      var resp;
      try {
        resp = await http.post(_url + '$endpoint', body: json.encode(body), );
        if (resp.statusCode == 200) {
          return json.decode(resp.body);
        } else {
          return {'status': 2, 'message': 'Ups! Algo salió mal. Intentalo de nuevo', 'body': null};
        }
      }
      
      //STATUS = 1 APLICA PARA CUANDO NO TIENE CONEXION A INTERNET
      //STATUS = 2 APLICA PARA CUANDO ALGO SALE MAL POR PARTE DEL CLIENTE
      //STATUS = 0 NO SE HIZO NINGUNA PETICION
      on SocketException {
        return {'status': 1, 'message': 'Por favor verifica tu conexión a internet', 'body': null};
          // controlador = 'sinConexion';
      } on http.ClientException {
        // print('ClientException');
        return {'status': 2, 'message': 'Ups! Algo salió mal. Intentalo de nuevo', 'body': null};
      }
      
      catch (e) {
        // print('No hizo la petición' + e);
        return {'status': 0, 'message': 'No hizo la petición', 'body': null};
      }
  }

  /*Peticion encargada de realizar la actualización del perfil del usuario */
  Future<Map<String, dynamic>> putPeticion(String endpoint, body) async {
      var resp;
      try {
        resp = await http.put(_url + '$endpoint', body: json.encode(body), );
        if (resp.statusCode == 200) {
          return json.decode(resp.body);
        } else {
          return {'status': 2, 'message': 'Ups! Algo salió mal. Intentalo de nuevo', 'body': null};
        }
      }
      
      //STATUS = 1 APLICA PARA CUANDO NO TIENE CONEXION A INTERNET
      //STATUS = 2 APLICA PARA CUANDO ALGO SALE MAL POR PARTE DEL CLIENTE
      //STATUS = 0 NO SE HIZO NINGUNA PETICION
      on SocketException {
        return {'status': 1, 'message': 'Por favor verifica tu conexión a internet', 'body': null};
          // controlador = 'sinConexion';
      } on http.ClientException {
        // print('ClientException');
        return {'status': 2, 'message': 'Ups! Algo salió mal. Intentalo de nuevo', 'body': null};
      }
      
      catch (e) {
        // print('No hizo la petición' + e);
        return {'status': 0, 'message': 'No hizo la petición', 'body': null};
      }
  }

  /*Peticion encargada de obtener la información de los perfiles de los usuarios */
  Future<Map<dynamic, dynamic>> getInfoProfile() async {
      try {
        final resp = await http.get(_url + '/users.json');
        if (resp.statusCode == 200) {
          return json.decode(resp.body);
        } else {
          return {'status': 2, 'message': 'Ups! Algo salió mal. Intentalo de nuevo', 'body': null};
        }
      }
      
      //STATUS = 1 APLICA PARA CUANDO NO TIENE CONEXION A INTERNET
      //STATUS = 2 APLICA PARA CUANDO ALGO SALE MAL POR PARTE DEL CLIENTE
      //STATUS = 0 NO SE HIZO NINGUNA PETICION
      on SocketException {
        return {'status': 1, 'message': 'Por favor verifica tu conexión a internet', 'body': null};
          // controlador = 'sinConexion';
      } on http.ClientException {
        // print('ClientException');
        return {'status': 2, 'message': 'Ups! Algo salió mal. Intentalo de nuevo', 'body': null};
      }
      
      catch (e) {
        // print('No hizo la petición' + e);
        return {'status': 0, 'message': 'No hizo la petición', 'body': null};
      }
  }

  /*Encripta cualquier String usando AES*/
  String encripted(dato){
    datoEncrip = encriptar.encryptAESCryptoJS(dato, key);
    return datoEncrip;
  }

  /*Desencripta cualquier String usando AES*/
  String desencripted(dato){
    String datoDesencrip = encriptar.decryptAESCryptoJS(dato, key);
    return datoDesencrip;
  }

}
