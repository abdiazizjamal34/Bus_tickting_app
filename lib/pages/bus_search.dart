import 'package:flutter/material.dart';
import 'bus_list.dart'; // Make sure to import the BusListPage

class BusSearchPage extends StatefulWidget {
  const BusSearchPage({super.key});

  @override
  _BusSearchPageState createState() => _BusSearchPageState();
}

class _BusSearchPageState extends State<BusSearchPage> {
  final List<String> locations = [
    'Jijiga',
    " Addis Ababa",
    'Dire Dawa',
    'Wajale'
  ];
  String? selectedFrom;
  String? selectedTo;
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Search'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select your Trip",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(),
                ),
                value: selectedFrom,
                items: locations.map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFrom = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a departure location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                ),
                value: selectedTo,
                items: locations.map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTo = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a destination location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date of Departure',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date of departure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusListPage(
                            from: selectedFrom,
                            to: selectedTo,
                            date: dateController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Search Buses'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
