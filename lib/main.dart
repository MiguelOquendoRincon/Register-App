import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:register_application/routes/routes.dart';
import 'package:register_application/src/preferences/preferences.dart';



class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Usuarios',
      theme: ThemeData(
        primaryColor: Color(0xFFF5C6BC0),
        secondaryHeaderColor: Color(0xFFF42A5F5),
        backgroundColor: Color(0xFFF949494),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: 'login',
      routes: Rutas.getRutas(),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences.getInstPref();
  prefs.cargarPref();
  runApp(MyApp());
}
