import 'package:flutter/material.dart';
import 'package:bus_ticketing_app/pages/bus_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showInitialContent = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showInitialContent = false;
      });
    });
  }

  void navigateToBusSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BusSearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Ticketing App'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showInitialContent) ...[
              Image.asset('assets/img/bus1.jpeg'),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Bus Ticketing App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ] else ...[
              
              const Text(
                "Select your Trip",
                textDirection: TextDirection.ltr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToBusSearch,
                child: const Text('Go to Bus Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
