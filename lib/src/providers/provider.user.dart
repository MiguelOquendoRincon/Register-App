import 'package:register_application/src/providers/provider.data.dart';

class UserProvider {
  DataProvider datos = DataProvider();

  /*Peticion usada para registrar un usuario nuevo, ambas peticiones pasan por sus respectivos metodos de validación en la clase DataProvider*/
  Future<Map<dynamic, dynamic>> signUp(String email, String password, String name, String lastName, String birthDayDate, List directions) async {
    
    var encryptPass = datos.encripted(password);

    final authData = {
      "email": email,
      "password": encryptPass,
      "name": name,
      "lastName": lastName,
      "birthdayDate": birthDayDate,
      "directions": directions,
    };

    final resp = await datos.postPeticion('/users.json', authData);
    Map<String, dynamic> decodedResp = resp;

    return {
      'status': true,
      'userId' : decodedResp['name'],
    };
  }

  /*Petición para actualizar la información de un perfil*/
  Future<Map<dynamic, dynamic>> updateInfo(String userId, String email, String encryptPass, String name, String lastName, String birthDayDate, List directions) async {
    final authData = {
      "email": email,
      "password": encryptPass,
      "name": name,
      "lastName": lastName,
      "birthdayDate": birthDayDate,
      "directions": directions,
    };

    final resp = await datos.putPeticion('/users/$userId.json', authData);
    Map<String, dynamic> decodedResp = resp;
    return {
      'status': true,
      'userId' : decodedResp,
    };
  }

}