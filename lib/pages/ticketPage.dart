import 'package:flutter/material.dart';
import 'home_page.dart'; // Import your HomePage

class TicketPage extends StatelessWidget {
  final String busNumber;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final String passengerName;
  final String phoneNumber;
  final List<int> selectedSeats;

  const TicketPage({
    super.key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.passengerName,
    required this.phoneNumber,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false, // Removes all previous routes
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'bus number',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(busNumber, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Form',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  from,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TO',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  to,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                color: Colors.black,
                width: 120,
                height: 120,
                child: const Center(
                  child: Text(
                    'QR CODE',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'departure time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(departureTime, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Arrival time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(arrivalTime, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              passengerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              phoneNumber,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selected sets',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              'seat ${selectedSeats.join(' : ')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'info@mybus.com',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
