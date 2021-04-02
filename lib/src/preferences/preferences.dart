import 'package:shared_preferences/shared_preferences.dart';


/*Clase usada para almacenar y obtener las preferencias del usuario en cualquier pantalla de la aplicación. */
class UserPreferences{


  static UserPreferences _instancia = new UserPreferences._internal();
  SharedPreferences _prefs;
  

  factory UserPreferences(){
    return _instancia;
  }
  UserPreferences._internal();

  static UserPreferences getInstPref(){
    if(_instancia == null) _instancia = new UserPreferences._internal();
    return _instancia; 
  }

  void cargarPref() async{
    _prefs = await SharedPreferences.getInstance();
  }

                                           
//   ####  ###### ##### ##### ###### #####  
//  #      #        #     #   #      #    # 
//   ####  #####    #     #   #####  #    # 
//       # #        #     #   #      #####  
//  #    # #        #     #   #      #   #  
//   ####  ######   #     #   ###### #    # 
  set userId(String id) => _prefs.setString('userId', id); 

  set email(String email) => _prefs.setString('email', email);

  set password(String password) => _prefs.setString('password', password);

  set name(String name) => _prefs.setString('name', name); 

  set lastName(String lastName) => _prefs.setString('lastName', lastName); 

  set birthdayDate(String birthdayDate) => _prefs.setString('birthdayDate', birthdayDate); 

  set directions(String directions) => _prefs.setString('directions', directions); 

//   ####  ###### ##### ##### ###### #####  
//  #    # #        #     #   #      #    # 
//  #      #####    #     #   #####  #    # 
//  #  ### #        #     #   #      #####  
//  #    # #        #     #   #      #   #  
//   ####  ######   #     #   ###### #    # 

  get userId => _prefs.getString('userId' ?? ''); 

  get email => _prefs.getString('email' ?? '');

  get password => _prefs.getString('password' ?? ''); 

  get name => _prefs.getString('name' ?? ''); 

  get lastName => _prefs.getString('lastName' ?? ''); 

  get birthdayDate => _prefs.getString('birthdayDate' ?? 'null'); 

  get directions => _prefs.getString('directions' ?? []); 

}