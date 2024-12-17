import 'package:flutter/material.dart';
import 'bus_list.dart'; // Import the BusListPage

class BusSearchPage extends StatefulWidget {
  const BusSearchPage({super.key});

  @override
  _BusSearchPageState createState() => _BusSearchPageState();
}

class _BusSearchPageState extends State<BusSearchPage> {
  final List<String> locations = [
    'Jijiga',
    "Addis Ababa",
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
    // MediaQuery for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; // Breakpoint for larger screens

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with responsive height
            Container(
              height: isLargeScreen ? 250 : 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    Text(
                      "Let's",
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    Text(
                      "Make your\nTrip good",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Form Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Trip",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Responsive "From" Input
                    SizedBox(
                      width:
                          isLargeScreen ? screenWidth * 0.7 : double.infinity,
                      child: _buildDropdownField(
                        hint: "From",
                        icon: Icons.home,
                        value: selectedFrom,
                        onChanged: (value) {
                          setState(() {
                            selectedFrom = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Responsive "To" Input
                    SizedBox(
                      width:
                          isLargeScreen ? screenWidth * 0.7 : double.infinity,
                      child: _buildDropdownField(
                        hint: "To",
                        icon: Icons.location_pin,
                        value: selectedTo,
                        onChanged: (value) {
                          setState(() {
                            selectedTo = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date of Departure
                    SizedBox(
                      width:
                          isLargeScreen ? screenWidth * 0.7 : double.infinity,
                      child: _buildDateField(context),
                    ),
                    const SizedBox(height: 20),

                    // Terms & Privacy Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                          activeColor: Colors.teal,
                        ),
                        const Text(
                          "I agree to the ",
                          style: TextStyle(color: Colors.black87),
                        ),
                        const Text(
                          "Terms & Privacy",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Responsive "Search Bus" Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
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
                        child: const Text(
                          'Search bus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Dropdown Field Widget
  Widget _buildDropdownField({
    required String hint,
    required IconData icon,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        value: value,
        items: locations.map((location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(location),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a location';
          }
          return null;
        },
      ),
    );
  }

  // Date Field Widget
  Widget _buildDateField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: dateController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          hintText: 'Date of departure',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
    );
  }
}
