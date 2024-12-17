// FILE: main.dart
import 'package:flutter/material.dart';
import 'package:bus_ticketing_app/pages/home_page.dart';

void main() {
  runApp(const BusTicketingApp());
}

class BusTicketingApp extends StatelessWidget {
  const BusTicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bus Ticketing App',
      home: HomePage(),
    );
  }
}