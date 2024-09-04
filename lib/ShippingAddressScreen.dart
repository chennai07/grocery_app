import 'package:flutter/material.dart';
import 'package:grocery_app/AccountScreen.dart';
import 'package:grocery_app/database.dart';
import 'package:sqflite/sqflite.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  // Define controllers to retrieve the text entered by the user
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _testDatabase();
  }

  Future<void> _testDatabase() async {
    final db = await _dbHelper.database;

    // Insert a test record
    await db.insert(
      'shipping_addresses',
      {
        'user_id': 1,
        'recipient_name': 'John Doe',
        'street_address': '123 Elm Street',
        'city': 'Somewhere',
        'state': 'CA',
        'postal_code': '90210',
        'country': 'USA',
        'phone_number': '123-456-7890'
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Query the records
    final List<Map<String, dynamic>> maps = await db.query('shipping_addresses');
    print('Records in the table: $maps');

    // Check if the record was inserted
    if (maps.isNotEmpty) {
      print('Database connection and operations are working!');
    } else {
      print('Failed to insert or query records.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(
                    labelText: 'Postal Code',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your postal code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Handle form submission
                      // For example, you might save the address to a database or navigate to another screen
                      final address = {
                        'name': _nameController.text,
                        'address': _addressController.text,
                        'city': _cityController.text,
                        'state': _stateController.text,
                        'postalCode': _postalCodeController.text,
                        'country': _countryController.text,
                      };
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Address submitted: ${address['name']}')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountScreen()),
                      ); // Navigate to the next screen
                    }
                  },
                  child: Container(
                    width: 380,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xff6CC51D),
                    ),
                    child: Center(
                      child: Text('Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
