import 'package:flutter/material.dart';
import 'payment.dart'; // Import the PaymentPage

class SeatPlanPage extends StatefulWidget {
  final String busNumber;
  final String departureTime;
  final String from;
  final String to;
  final String date;
  final double price;

  const SeatPlanPage({super.key, 
    required this.busNumber,
    required this.departureTime,
    required this.from,
    required this.to,
    required this.date,
    required this.price,
  });

  @override
  _SeatPlanPageState createState() => _SeatPlanPageState();
}

class _SeatPlanPageState extends State<SeatPlanPage> {
  List<String> seats = List.generate(12, (index) => 'Available');
  ValueNotifier<List<int>> selectedSeatsNotifier = ValueNotifier<List<int>>([]);

  void toggleSeat(int index) {
    setState(() {
      if (seats[index] == 'Available') {
        seats[index] = 'Selected';
        selectedSeatsNotifier.value = List.from(selectedSeatsNotifier.value)
          ..add(index + 1); // Store seat number
      } else if (seats[index] == 'Selected') {
        seats[index] = 'Available';
        selectedSeatsNotifier.value = List.from(selectedSeatsNotifier.value)
          ..remove(index + 1); // Remove seat number
      }
    });
  }

  @override
  void dispose() {
    selectedSeatsNotifier.dispose();
    super.dispose();
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
              'Bus Number: ${widget.busNumber}\n'
              'Departure: ${widget.departureTime}\n'
              'From: ${widget.from} - To: ${widget.to}\n'
              'Price per seat: \$${widget.price}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 5,
              ),
              itemCount: seats.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => toggleSeat(index),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: seats[index] == 'Available'
                    //       ? Colors.green
                    //       : Colors.red,
                    //   borderRadius: BorderRadius.circular(8),
                    // ),
                    // decoration: BoxDecoration(
                    //   color: seats[index] == 'Available'
                    //       ? Colors.green
                    //       : Colors.red,
                    //   borderRadius: BorderRadius.circular(8),
                    // ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.airline_seat_legroom_normal_sharp,
                            color: seats[index] == 'Available'
                                ? Colors.green
                                : Colors.red,
                          ),
                          Text(
                            'Seat ${index + 1}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
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
                ValueListenableBuilder<List<int>>(
                  valueListenable: selectedSeatsNotifier,
                  builder: (context, selectedSeats, child) {
                    return Text(
                      'Selected Seats: ${selectedSeats.join(', ')}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<List<int>>(
                  valueListenable: selectedSeatsNotifier,
                  builder: (context, selectedSeats, child) {
                    return ElevatedButton(
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
                                  ),
                                ),
                              );
                            },
                      child: const Text('Confirm Booking'),
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
