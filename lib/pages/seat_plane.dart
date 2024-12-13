import 'package:flutter/material.dart';

class SeatPlanPage extends StatefulWidget {
  final String busNumber;
  final String departureTime;
  final String date;
  final String from;
  final String to;
  final double price;

  const SeatPlanPage({super.key, 
    required this.busNumber,
    required this.departureTime,
    required this.date,
    required this.from,
    required this.to,
    required this.price,
  });

  @override
  _SeatPlanPageState createState() => _SeatPlanPageState();
}

class _SeatPlanPageState extends State<SeatPlanPage> {
  List<String> seats = List.generate(12, (index) => 'Available');
  List<int> selectedSeats = [];

  void toggleSeat(int index) {
    if (seats[index] == 'Available') {
      setState(() {
        seats[index] = 'Selected';
        selectedSeats.add(index + 1); // Store seat number
      });
    } else if (seats[index] == 'Selected') {
      setState(() {
        seats[index] = 'Available';
        selectedSeats.remove(index + 1); // Remove seat number
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Plan'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Board Point: ${widget.from} - ${widget.departureTime}\nDrop Point: ${widget.to} - 07:30',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                Color seatColor;
                if (seats[index] == 'Sold Out') {
                  seatColor = Colors.red; // Sold Out
                } else if (seats[index] == 'Selected') {
                  seatColor = Colors.purple; // Selected
                } else {
                  seatColor = Colors.blue; // Available
                }

                return GestureDetector(
                  onTap: () {
                    if (seats[index] != 'Sold Out') {
                      toggleSeat(index);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: seatColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Selected Seats: ${selectedSeats.join(', ')}'),
                Text('Total Price: Bir ${widget.price * selectedSeats.length}'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle booking confirmation logic here
                    if (selectedSeats.isNotEmpty) {
                      // Proceed with booking
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Booking Confirmed'),
                          content: Text(
                              'You have booked seats: ${selectedSeats.join(', ')}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Show a message if no seats are selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select at least one seat.')),
                      );
                    }
                  },
                  child: const Text('Confirm Booking'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 