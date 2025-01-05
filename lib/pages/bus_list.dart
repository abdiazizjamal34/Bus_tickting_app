import 'package:flutter/material.dart';
import 'seat_plane.dart';

// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class BusListPage extends StatefulWidget {
  final String? from;
  final String? to;
  final String? date;

  const BusListPage({super.key, this.from, this.to, this.date});

  @override
  _BusListPageState createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> buses = [];
  List<Map<String, dynamic>> filteredBuses = [];

  //   {
  //     'number': 'BADER 8322',
  //     'departureTime': '06:30 - 08:00',
  //     'date': 'November 28, 2024',
  //     'from': 'Jijiga',
  //     'to': 'Wajale',
  //     'price': 300.0,
  //   },
  //   // Add more bus data here...
  // ];
  @override
  void initState() {
    super.initState();
    print(
        'From: ${widget.from}, To: ${widget.to}, Date: ${widget.date}'); // Debug print statement
    fetchBuses();
  }

  // Future<void> loadBusData() async {
  //   try {
  //     final String response =
  //         await rootBundle.loadString('assets/jeson/buses.json');
  //     final data = await json.decode(response);
  //     setState(() {
  //       buses = List<Map<String, dynamic>>.from(data['buses']);
  //       print('Fetched Buses: $buses'); // Debug print statement
  //       filterBuses();
  //     });
  //   } catch (e) {
  //     print('Error loading bus data: $e');
  //   }
  // }

  Future<void> fetchBuses() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('buses').get();
      setState(() {
        buses = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          // Ensure that reservedSeats is a List<int>
          if (data['reservedSeats'] != null) {
            data['reservedSeats'] = List<int>.from(data['reservedSeats']);
          } else {
            data['reservedSeats'] = [];
          }

          print("Fetched Bus: $data"); // Debug print

          return {...data, 'id': doc.id}; // Include document ID
        }).toList();
        filterBuses(); // Assuming this is a function to filter the bus list
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching buses: $e")),
      );
    }
  }

  void filterBuses() {
    setState(() {
      print('Filtering Buses with criteria:');
      print('From: ${widget.from}');
      print('To: ${widget.to}');
      print('Date: ${widget.date}');

      filteredBuses = buses.where((bus) {
        print('Checking bus: $bus');
        bool matchesFrom = widget.from != null &&
            bus['from'].trim().toLowerCase() ==
                widget.from!.trim().toLowerCase();
        bool matchesTo = widget.to != null &&
            bus['to'].trim().toLowerCase() == widget.to!.trim().toLowerCase();

        // Parse the dates to DateTime objects for accurate comparison
        bool matchesDate = false;
        if (widget.date != null) {
          try {
            DateTime busDate = DateTime.parse(bus['date'].trim());
            DateTime userDate = DateTime.parse(widget.date!.trim());
            matchesDate = busDate.year == userDate.year &&
                busDate.month == userDate.month &&
                busDate.day == userDate.day;
          } catch (e) {
            print('Error parsing date: $e');
          }
        }

        print(
            'matchesFrom: $matchesFrom, matchesTo: $matchesTo, matchesDate: $matchesDate');

        return matchesFrom && matchesTo && matchesDate;
      }).toList();

      print('Filtered Buses: $filteredBuses'); // Debug print statement
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Listings'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'From: ${widget.from}, To: ${widget.to}, Date: ${widget.date}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: filteredBuses.isEmpty
                ? const Center(
                    child: Text(
                      'No buses available today',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredBuses.length,
                    itemBuilder: (context, index) {
                      final bus = filteredBuses[index];

                      // Debugging print statements
                      print("Bus Details: $bus");

                      return GestureDetector(
                        onTap: () {
                          // Assuming you're in a function that handles bus selection
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => SeatPlanPage(
                              busNumber: bus['busNumber'] ?? 'Unknown',
                              departureTime: bus['departure'] ?? 'Unknown',
                              arrivalTime: bus['arrival'] ?? 'Unknown',
                              date: bus['date'] ?? 'Unknown',
                              from: bus['from'] ?? 'Unknown',
                              to: bus['to'] ?? 'Unknown',
                              price: bus['price']?.toDouble() ?? 0.0,
                              seatreserved: List<int>.from(
                                  bus['seatreseve'] ?? []), // Correctly cast
                              busId: bus['id'] ?? 'Unknown',
                            ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          color: Colors.lightBlue,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      bus['busNumber'] ?? 'No Bus Number',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'ETB ${bus['price']?.toString() ?? '0'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  bus['date'] ?? 'No Date',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Departure Time: ${bus['departure'] ?? 'No Time'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Arrival Time: ${bus['arrival'] ?? 'No Time'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.white),
                                    const SizedBox(width: 5),
                                    Text(
                                      'From: ${bus['from'] ?? 'Unknown'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.white),
                                    const SizedBox(width: 5),
                                    Text(
                                      'To: ${bus['to'] ?? 'Unknown'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
