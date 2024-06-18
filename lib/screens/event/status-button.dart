import 'package:flutter/material.dart';

class GoingButton extends StatefulWidget {
  @override
  _GoingButtonState createState() => _GoingButtonState();
}

class _GoingButtonState extends State<GoingButton> {
  String? _selectedStatus;
  final List<String> _statuses = ['Going', 'Interested'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      decoration: BoxDecoration(
        color: Color(0xffFF7A00), // Facebook-like blue color
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          value: _selectedStatus,
          hint: Text(
            'Going',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue;
            });
          },
          selectedItemBuilder: (BuildContext context) {
            return _statuses.map<Widget>((String status) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList();
          },
          items: _statuses.map<DropdownMenuItem<String>>((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(
                status,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
