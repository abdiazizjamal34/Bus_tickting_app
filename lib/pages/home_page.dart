import 'package:flutter/material.dart';
import 'package:bus_ticketing_app/pages/bus_search.dart';
import 'package:bus_ticketing_app/pages/yourTrip.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bus_ticketing_app/pages/auth/authmethod.dart';
import 'package:bus_ticketing_app/pages/auth/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showInitialContent = true;

  final AuthMethod authMethod = AuthMethod();
  String userName = "User"; // Default name

  @override
  void initState() {
    super.initState();
    userName = authMethod.getCurrentUserName();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showInitialContent = false;
      });
    });
  }

  // void navigateToBusSearch() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const BusSearchPage()),
  //   );
  // }
  void navigateToBusSearch() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        // child: CircularProgressIndicator(
        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),

        child: SpinKitFadingCircle(
          color: Colors.teal,
          size: 50.0,
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    Navigator.pop(context); // Close the loading indicator
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusSearchPage()),
    );
  }

  void showThanksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome to Bus Ticketing App'),
          content: const Text(
              'Thanks for choosing us, we are here to help you \n\nCall us on +251 911 111 111'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void NavigateToTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Trip()),
    );
  }

  void thanksForChoosingUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome to Bus Ticketing App'),
          content: const Text(
              'Thanks for choosing us, we are here to help you \n\nCall us on +251 911 111 111'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Ticketing App'),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.only(bottom: 1),
              duration: const Duration(seconds: 20),
              curve: Curves.fastOutSlowIn,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_2,
                        size: 60,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'welcome $userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Home
              },
            ),
            ListTile(
              leading: const Icon(Icons.bus_alert),
              title: const Text('Bus Search'),
              onTap: () {
                Navigator.pop(context);
                navigateToBusSearch();
              },
            ),
            ListTile(
              leading: const Icon(Icons.airplane_ticket),
              title: const Text('Your Trip'),
              onTap: () {
                Navigator.pop(context);
                NavigateToTrip();
              },
            ),
            const Divider(), // Add a divider for better separation
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                // Call your logout method here
                await AuthMethod()
                    .logoutUser(); // Ensure you have a logout method
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), // Navigate to Login Page
                );
              },
            ),
          ],
        ),
      ),

      // Todo: body part
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showInitialContent) ...[
              Image.asset('assets/img/bus1.jpeg', width: 200, height: 200),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Bus Ticketing App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ] else ...[
              // Main Logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade800, Colors.teal.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                width: 150,
                height: 150,
                child: const Center(
                  child: Text(
                    "MaY Bus",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Select Your Option Text
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: const Text(
                  "select your option",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Circular Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: navigateToBusSearch,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.directions_bus,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Select trip",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          thanksForChoosingUs(context);
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.call,
                              color: Colors.redAccent,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Contact Us",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Bottom Shadow
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 10,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}