import 'package:flutter/material.dart';
import 'ticketPage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatelessWidget {
  final String busNumber;
  final String departureTime;
  final String from;
  final String date;
  final String to;
  final double price;
  final List<int> selectedSeats;
  final String busId;

  const PaymentPage({
    super.key,
    required this.busNumber,
    required this.departureTime,
    required this.from,
    required this.to,
    required this.date,
    required this.price,
    required this.busId,
    required this.selectedSeats,
  });

  Future<void> saveTripDetails(String userId, Map<String, dynamic> tripData) async {
  try {
    await FirebaseFirestore.instance.collection('trips').add({
      'userId': userId,
      'busNumber': tripData['busNumber'],
      'passengerName': tripData['passengerName'],
      'from': tripData['from'],
      'to': tripData['to'],
      'date': tripData['date'],
      'createdAt': FieldValue.serverTimestamp(), // Optional: timestamp
    });
  } catch (e) {
    print('Failed to save trip details: $e');
  }
}

  Future<void> updateReservedSeat(String id, Map<String, dynamic> data) async {
    try {
      // Assume you have the bus document ID
      String busDocId = busId; // Adjust this if you use a different ID

      // Reference the specific bus document
      DocumentReference busDoc =
          FirebaseFirestore.instance.collection('buses').doc(busDocId);

      // Update the reservedSeats field
      await busDoc.update({
        'seatreseve':
            FieldValue.arrayUnion(selectedSeats), // Add selected seats
      });
    } catch (e) {
      print('Failed to update reserved seats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = selectedSeats.length * price;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final pickupController = TextEditingController();
    final ValueNotifier<String?> paymentMethodNotifier =
        ValueNotifier<String?>(null);

    String formattedDate(date) {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('EEEE, MMMM d, y').format(dateTime);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blueGrey,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 32,
              vertical: isSmallScreen ? 16 : 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(isSmallScreen ? 6.0 : 12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              from,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 16 : 20),
                            ),
                            const Icon(Icons.arrow_forward),
                            Text(
                              to,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 16 : 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              departureTime,
                              style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '11:00',
                              style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          formattedDate(date),
                          style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 18,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: const Color.fromARGB(26, 225, 225, 225),
                    shadowColor: Colors.blueGrey,
                    elevation: 0,
                    margin: EdgeInsets.all(isSmallScreen ? 6.0 : 12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Selected Seats',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 14 : 18),
                            ),
                            Text(
                              'Seat ${selectedSeats.join(', ')}',
                              style:
                                  TextStyle(fontSize: isSmallScreen ? 14 : 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount per seat',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 14 : 18),
                            ),
                            Text(
                              'ETB $price',
                              style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 14 : 18),
                            ),
                            Text(
                              'ETB ${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(isSmallScreen ? 6.0 : 12.0),
                    child: Column(
                      children: [
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: paymentMethodNotifier,
                          builder: (context, paymentMethod, child) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Image.asset(
                                        'assets/img/ebir.jpeg',
                                        width: isSmallScreen ? 50 : 70,
                                        height: isSmallScreen ? 50 : 70,
                                      ),
                                    ],
                                  ),
                                  leading: Radio<String>(
                                    value: 'Ebir',
                                    groupValue: paymentMethod,
                                    onChanged: (value) {
                                      paymentMethodNotifier.value = value;
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Image.asset(
                                        'assets/img/cbebir.jpeg',
                                        width: isSmallScreen ? 50 : 70,
                                        height: isSmallScreen ? 50 : 70,
                                      ),
                                    ],
                                  ),
                                  leading: Radio<String>(
                                    value: 'Kafi',
                                    groupValue: paymentMethod,
                                    onChanged: (value) {
                                      paymentMethodNotifier.value = value;
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(isSmallScreen ? 6.0 : 12.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 4) {
                              return 'Name must be at least 3 characters';
                            }
                            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                              return 'Please enter only alphabetic characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: pickupController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: 'Phone Number',
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid phone number';
                            }
                            if (!RegExp('[0-9 ]').hasMatch(value)) {
                              return 'Please enter only numeric characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 20 : 40,
                          vertical: isSmallScreen ? 10 : 20,
                        ),
                      ),
                      onPressed: () async {
  if (formKey.currentState!.validate() && paymentMethodNotifier.value != null) {
    final ticketData = {
      'busNumber': busNumber,
      'departureTime': departureTime,
      'from': from,
      'to': to,
      'date': date,
      'price': price,
      'selectedSeats': selectedSeats,
      'totalAmount': totalAmount,
      'passengerName': nameController.text,
      'phoneNumber': pickupController.text,
      'paymentMethod': paymentMethodNotifier.value,
    };

    final data = {
      'reservedSeats': selectedSeats,
    };
    await updateReservedSeat(busId, data);

    // Get the current user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Save trip details
    await saveTripDetails(userId, ticketData);

    // Navigate to the TicketPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketPage(
          busNumber: busNumber,
          from: from,
          to: to,
          departureTime: departureTime,
          arrivalTime: '11:00',
          passengerName: nameController.text,
          phoneNumber: pickupController.text,
          selectedSeats: selectedSeats,
        ),
      ),
    );
  } else if (paymentMethodNotifier.value == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a payment method')),
    );
  }
},
                      child: const Text(
                        'Confirm Payment',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}