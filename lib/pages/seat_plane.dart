import 'package:flutter/material.dart';

import 'payment.dart'; // Import the PaymentPage

class SeatPlanPage extends StatefulWidget {
  final String busNumber;
  final String departureTime;
  final String arrivalTime;
  final String from;
  final String to;
  final String date;
  final double price;
  final List<int> seatreserved;
  final String busId;

  const SeatPlanPage({
    super.key,
    required this.busNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.from,
    required this.to,
    required this.date,
    required this.price,
    required this.seatreserved,
    required this.busId,
  });

  @override
  _SeatPlanPageState createState() => _SeatPlanPageState();
}

class _SeatPlanPageState extends State<SeatPlanPage> {
  // Initialize a list to track the availability of seats
  List<String> seats = List.generate(13, (index) => 'Available');
  // Use ValueNotifier to track selected seat indices
  ValueNotifier<List<int>> selectedSeatsNotifier = ValueNotifier<List<int>>([]);

  @override
  void initState() {
    super.initState();
    // Mark reserved seats as 'Reserved'
    for (var seat in widget.seatreserved) {
      if (seat > 0 && seat <= seats.length) {
        seats[seat - 1] = 'Reserved'; // Update seat status
      }
    }
  }

  // Toggle the seat selection and update the seat state
  void toggleSeat(int index) {
    setState(() {
      if (seats[index] == 'Available') {
        // Mark seat as selected and add to the selectedSeatsNotifier list
        seats[index] = 'Selected';
        selectedSeatsNotifier.value = List.from(selectedSeatsNotifier.value)
          ..add(index + 1); // Store seat number
      } else if (seats[index] == 'Selected') {
        // Mark seat as available and remove from the selectedSeatsNotifier list
        seats[index] = 'Available';
        selectedSeatsNotifier.value = List.from(selectedSeatsNotifier.value)
          ..remove(index + 1); // Remove seat number
      }
      // Do nothing if the seat is reserved
    });
  }

  @override
  void dispose() {
    // Dispose of ValueNotifier to avoid memory leaks
    selectedSeatsNotifier.dispose();
    super.dispose();
  }

  // Helper function to build a row of seats dynamically
  Widget buildSeatRow(List<int> seatIndices) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: seatIndices.map((index) {
          return GestureDetector(
            onTap: () {
              if (seats[index] == 'Available') {
                toggleSeat(index); // Handle seat tap
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.event_seat,
                size: 50,
                // Change color based on seat state
                color: seats[index] == 'Available'
                    ? Colors.green
                    : seats[index] == 'Selected'
                        ? Colors.red
                        : Colors.grey, // Color for reserved seats
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Plan'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Bus details section
          Card(
            elevation: 0,
            margin: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(widget.from,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(width: 170),
                    const Icon(Icons.arrow_forward),
                    const SizedBox(width: 150),
                    Text(widget.to,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      widget.departureTime,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 350),
                    Text(
                      widget.arrivalTime,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Seat selection section
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    const SizedBox(width: 120),
                    Image.asset(
                      'assets/img/stering.jpeg',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    buildSeatRow([0, 1]),
                    const SizedBox(width: 0),
                    buildSeatRow([9]),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    buildSeatRow([2, 3]),
                    const SizedBox(width: 0),
                    buildSeatRow([10]),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    buildSeatRow([4, 5]),
                    const SizedBox(width: 0),
                    buildSeatRow([11]),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    buildSeatRow([6, 7]),
                    const SizedBox(width: 0),
                    buildSeatRow([12]),
                  ],
                ),
              ],
            ),
          ),

          // Selected seats and confirm booking button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ValueListenableBuilder<List<int>>(
                  valueListenable: selectedSeatsNotifier,
                  builder: (context, selectedSeats, child) {
                    return Text(
                      'Selected Seats: ${selectedSeats.isEmpty ? 'None' : selectedSeats.join(', ')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<List<int>>(
                  valueListenable: selectedSeatsNotifier,
                  builder: (context, selectedSeats, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: selectedSeats.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                      busNumber: widget.busNumber,
                                      departureTime: widget.departureTime,
                                      from: widget.from,
                                      to: widget.to,
                                      date: widget.date,
                                      price: widget.price,
                                      selectedSeats: selectedSeats,
                                      busId: widget.busId),
                                ),
                              );
                            },
                      child: const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}