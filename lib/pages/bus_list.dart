import 'dart:convert';

import 'package:flutter/material.dart';
import 'seat_plane.dart';
import 'package:flutter/services.dart';

class BusListPage extends StatefulWidget {
  final String? from;
  final String? to;
  final String? date;

  const BusListPage({super.key, this.from, this.to, this.date});

  @override
  _BusListPageState createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
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
    loadBusData();
  }

  Future<void> loadBusData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/jeson/buses.json');
      final data = await json.decode(response);
      setState(() {
        buses = List<Map<String, dynamic>>.from(data['buses']);
        print('Fetched Buses: $buses'); // Debug print statement
        filterBuses();
      });
    } catch (e) {
      print('Error loading bus data: $e');
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatPlanPage(
                                busNumber: bus['number'],
                                departureTime: bus['departureTime'],
                                date: bus['date'],
                                from: bus['from'],
                                to: bus['to'],
                                price: bus['price'],
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
                                      bus['number'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'ETB ${bus['price']}',
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
                                  bus['date'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  bus['departureTime'],
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
                                      'From: ${bus['from']}',
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
                                      'To: ${bus['to']}',
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
