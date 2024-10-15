import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class EMICalculatorScreen extends StatefulWidget {
  @override
  _EMICalculatorScreenState createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _tenureType = 'Years';

  double _emi = 0.0;
  double _totalInterest = 0.0;
  double _totalPrincipal = 0.0;

  // Function to calculate EMI
  void calculateEMI() {
    double principal = double.parse(_principalController.text);
    double interestRate = double.parse(_interestRateController.text) / 12 / 100;
    int tenure = _tenureType == 'Years'
        ? int.parse(_tenureController.text) * 12
        : int.parse(_tenureController.text);

    double power = (1 + interestRate);
    double emi = (principal * interestRate * (power)) / (power - 1);

    setState(() {
      _emi = emi;
      _totalInterest = emi * tenure - principal;
      _totalPrincipal = principal;
    });
  }

  // Function to select the date
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _principalController,
                decoration: InputDecoration(labelText: 'Principal Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter principal amount';
                  return null;
                },
              ),
              TextFormField(
                controller: _interestRateController,
                decoration: InputDecoration(labelText: 'Interest Rate (%)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter interest rate';
                  return null;
                },
              ),
              TextFormField(
                controller: _tenureController,
                decoration: InputDecoration(labelText: 'Tenure'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter tenure';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _tenureType,
                onChanged: (String? newValue) {
                  setState(() {
                    _tenureType = newValue!;
                  });
                },
                items: <String>['Years', 'Months']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Tenure Type'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        "Start Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}"),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    calculateEMI();
                  }
                },
                child: Text('Calculate EMI'),
              ),
              SizedBox(height: 20),
              _emi > 0
                  ? Column(
                children: [
                  Text('EMI: ${_emi.toStringAsFixed(2)}'),
                  SizedBox(height: 200, child: _buildPieChart()),
                ],
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.blue,
            value: _totalPrincipal,
            title: 'Principal: ${_totalPrincipal.toStringAsFixed(2)}',
          ),
          PieChartSectionData(
            color: Colors.red,
            value: _totalInterest,
            title: 'Interest: ${_totalInterest.toStringAsFixed(2)}',
          ),
        ],
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
      ),
    );
  }
}
