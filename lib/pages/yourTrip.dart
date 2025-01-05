import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Trip extends StatelessWidget {
  const Trip({super.key});


   String getFormattedDate(Timestamp lastUpdate) {
    DateTime dateTime = lastUpdate.toDate();
    DateFormat formatter = DateFormat('dd MMM HH:mm');
    return formatter.format(dateTime);
  }
  

  @override
  Widget build(BuildContext context) {
    // Get the current user ID
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Trip'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trips')
            .where('userId', isEqualTo: userId) // Filter by user ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No trips found.'));
          }

          // Build a list of trip cards
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // Get the data from the document
              Map<String, dynamic> tripData = document.data() as Map<String, dynamic>;

              return _buildTripCard(
                busNumber: tripData['busNumber'] ?? 'N/A',
                passengerName: tripData['passengerName'] ?? 'N/A',
                from: tripData['from'] ?? 'N/A',
                to: tripData['to'] ?? 'N/A',
                date: tripData['date'] ?? 'N/A',
                lastUpdate: tripData['createdAt'] ?? 'N/A', // Adjust based on your Firestore structure
              );
            }).toList(),
          );
        },
      ),
    );
  }
  Widget _buildTripCard({
    required String busNumber,
    required String passengerName,
    required String from,
    required String to,
    required String date,
    required Timestamp lastUpdate,
  }) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Bus Number:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 20),
              Text(busNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 2, color: Colors.black26),
          Row(
            children: [
              const SizedBox(width: 20),
              Text(passengerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 20),
                            Text(from, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

              const SizedBox(width: 70),
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 70),
              Text(to, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 10),
              Text(date, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(thickness: 2, color: Colors.black12),
          Row(
            children: [
              const SizedBox(width: 20),
              const Icon(Icons.refresh),
              Text('Last update: ${getFormattedDate(lastUpdate)}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}