import 'package:flutter/material.dart';
import 'seat_plane.dart';
import 'ticketPage.dart';

class PaymentPage extends StatelessWidget {
  final String busNumber;
  final String departureTime;
  final String from;
  final String date;
  final String to;
  final double price;
  final List<int> selectedSeats;

  const PaymentPage({
    super.key,
    required this.busNumber,
    required this.departureTime,
    required this.from,
    required this.to,
    required this.date,
    required this.price,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = selectedSeats.length * price;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final pickupController = TextEditingController();
    final ValueNotifier<String?> paymentMethodNotifier =
        ValueNotifier<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bus Number: $busNumber\n'
                'Departure: $departureTime\n'
                'From: $from - To: $to\n'
                'Selected Seats: ${selectedSeats.join(', ')}\n'
                'Total Amount: Birr ${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
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
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder<String?>(
                valueListenable: paymentMethodNotifier,
                builder: (context, paymentMethod, child) {
                  return Column(
                    children: [
                      ListTile(
                        title: const Text('Ebir'),
                        leading: Radio<String>(
                          value: 'Ebir',
                          groupValue: paymentMethod,
                          onChanged: (value) {
                            paymentMethodNotifier.value = value;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Kafi'),
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
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        paymentMethodNotifier.value != null) {
                      // Display confirmation dialog with new format
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bus Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('mybus003'),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'From',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(from),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'TO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(to),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Departure Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(departureTime),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Arrival Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('11:00'),
                                  ],
                                ),
                                const Divider(),
                                const Text(
                                  'Selected Seats',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Seat: ${selectedSeats.join(', ')}'),
                                const SizedBox(height: 10),
                                const Icon(
                                  Icons.email,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                                const Text(
                                  'info@mybus.com',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
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
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(color: Colors.teal),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (paymentMethodNotifier.value == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a payment method')),
                      );
                    }
                  },
                  child: const Text('Confirm Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
