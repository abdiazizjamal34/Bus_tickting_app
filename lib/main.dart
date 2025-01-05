// FILE: main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'protect.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyDTAqUfJql1zsSSNVob-oE9PaZYY9C3NX4",
    authDomain: "mybus-a6ff8.firebaseapp.com",
    projectId: "mybus-a6ff8",
    storageBucket: "mybus-a6ff8.firebasestorage.app",
    messagingSenderId: "295901224317",
    appId: "1:295901224317:web:61252c3d2f910eb7e7c014",
    measurementId: "G-1VVXDWJ595");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const BusTicketingApp());
}

class BusTicketingApp extends StatelessWidget {
  const BusTicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return const  MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Bus Ticketing App',
      home: AuthWrapper(),
    );
  }
}