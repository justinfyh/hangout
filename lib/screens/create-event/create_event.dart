import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _dateTimeController.text =
              DateFormat('MMM dd, yyyy HH:mm').format(combined);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/landing-background.png'), // replace with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Pick a GIF'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Gallery'),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Upload'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                    labelText: 'Event Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: 'Start date and time',
                    border: OutlineInputBorder()),
                onTap: () => _selectDateTime(context),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Add end time'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Repeat event'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('UTC+12'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                    labelText: 'Location', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Who can see it?', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                    labelText: 'What are the details?',
                    border: OutlineInputBorder()),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle event creation logic here
                  }
                },
                child: Text('Create event'),
                style: ElevatedButton.styleFrom(
                  // primary: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
