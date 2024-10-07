import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../controller/part_payment_controller.dart';

class PartPaymentTable extends StatefulWidget {
  @override
  _PartPaymentTableState createState() => _PartPaymentTableState();

}

final PartPaymentController controller = Get.find<PartPaymentController>();

class _PartPaymentTableState extends State<PartPaymentTable> {
  DateTime? _selectedDate;
  DateTime? _customSelectedDate;
  String _payingTerm = 'Tenure End';
  String _prePaymentType = 'Monthly';
  String? _amount;

  List<Map<String, dynamic>> _paymentRows = [];

  // Function to show the date picker and set the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            hintColor: Colors.teal,
            colorScheme: ColorScheme.light(primary: Colors.teal),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to show the date picker for custom date
  Future<void> _selectCustomDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _customSelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Colors.teal).copyWith(secondary: Colors.teal),
          ),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null && picked != _customSelectedDate) {
      setState(() {
        _customSelectedDate = picked;
      });
    }
  }

  void _addRow() {
    if (_amount != null && _selectedDate != null) {
      setState(() {
        _paymentRows.add({
          'prePaymentType': _prePaymentType,
          'amount': _amount,
          'startingDate': _selectedDate,
          'payingTerm': _payingTerm,
          'customDate': _payingTerm == 'Custom Date' ? _customSelectedDate : null,
        });

        // Reset fields
        _amount = null;
        _selectedDate = null;
        _customSelectedDate = null;
        _payingTerm = 'Tenure End';
      });
    }
  }

  void _deleteRow(int index) {
    setState(() {
      _paymentRows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Table(
            border: TableBorder.all(
              color: Colors.teal.shade300,
              width: 1,
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2),
            },
            children: [
              TableRow(children: [
                _buildHeaderCell('Part Payment Type'),
                _buildHeaderCell('Amount'),
                _buildHeaderCell('Starting From'),
                _buildHeaderCell('Paying Term'),
                _buildHeaderCell('Custom Date'),
                _buildHeaderCell('Actions'),
              ]),
            ] +
                List.generate(_paymentRows.length, (index) {
                  final row = _paymentRows[index];
                  return TableRow(children: [
                    Center(
                      child: Text(
                        row['prePaymentType'],
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: Text(
                        row['amount'],
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(row['startingDate']),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: Text(
                        row['payingTerm'],
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: Text(
                        row['customDate'] != null
                            ? DateFormat('dd/MM/yyyy').format(row['customDate'])
                            : 'N/A',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(child: _buildActionButtonsCell(index)),
                  ]);
                })
                +
                [
                  TableRow(children: [
                    _buildDropdownCell(['Monthly', 'Quarterly', 'Yearly', 'One time only']),
                    _buildTextFieldCell(),
                    _buildDateButtonCell(context, _selectedDate, _selectDate),
                    _buildDropdownCell(['Tenure End', 'Custom Date'], isPayingTerm: true),
                    _buildCustomDateButtonCell(context),
                    _buildAddButtonCell(),
                  ]),
                ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.teal.shade700,
      child: Center( // Center the text inside the header cell
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  Widget _buildDropdownCell(List<String> items, {bool isPayingTerm = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        value: isPayingTerm ? _payingTerm : _prePaymentType,
        decoration: InputDecoration(
          fillColor: Colors.white, // White background color for the dropdown
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
        ),
        dropdownColor: Colors.white,
        isExpanded: true,
        //underline: SizedBox(),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (isPayingTerm) {
              _payingTerm = newValue!;
            } else {
              _prePaymentType = newValue!;
            }
          });
        },
      ),
    );
  }

  Widget _buildTextFieldCell() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller.partPaymentAmount,
        decoration: InputDecoration(
          hintText: 'Part Payment Amount',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          _amount = value;
        },
      ),
    );
  }

  Widget _buildDateButtonCell(BuildContext context, DateTime? date, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => onPressed(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0), // Set circular radius to 0.0
          ),
        ),
        child: Text(
          date == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(date),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCustomDateButtonCell(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _payingTerm == 'Custom Date' ? () => _selectCustomDate(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0), // Set circular radius to 0.0
          ),
        ),
        child: Text(
          _customSelectedDate == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(_customSelectedDate!),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }


  Widget _buildAddButtonCell() {
    return Padding( // Add padding to create space from the top
      padding: const EdgeInsets.only(top: 10.0), // Adjust this value as needed
      child: Center( // Center the button
        child: ElevatedButton.icon(
          onPressed: _amount != null && _selectedDate != null ? _addRow : null,
          icon: Icon(Icons.add, color: Colors.teal.shade800, size: 16),
          label: Text('Add', style: TextStyle(color: Colors.teal.shade800, fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Button color set to white
            foregroundColor: Colors.teal.shade800, // Ensure text and icon color are teal
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0), // Square corners
            ),
          ),

        ),
      ),
    );
  }





  Widget _buildActionButtonsCell(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            _editRow(index);
          },
        ),
        SizedBox(width: 3.0,),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.black),
          onPressed: () => _deleteRow(index),
        ),
      ],
    );
  }

  void _editRow(int index) {
    // Prepopulate the fields with existing values
    setState(() {
      _prePaymentType = _paymentRows[index]['prePaymentType'];
      _amount = _paymentRows[index]['amount'];
      _selectedDate = _paymentRows[index]['startingDate'];
      _payingTerm = _paymentRows[index]['payingTerm'];
      _customSelectedDate = _paymentRows[index]['customDate'];

      // Remove the current row, so the user can edit and save as new
      _paymentRows.removeAt(index);
    });
  }

}
