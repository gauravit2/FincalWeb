import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fincalweb_project/helper/Calculate_button.dart';
import 'package:fincalweb_project/helper/InvestmentResult.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../../components/emi_calculator_components/partpayment_table.dart'; // For date formatting

class EmiCalculator extends StatefulWidget {
  const EmiCalculator({super.key});

  @override
  _EmiCalculatorState createState() => _EmiCalculatorState();
}

class _EmiCalculatorState extends State<EmiCalculator> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _principalController;
  late TextEditingController _interestRateController;
  late TextEditingController _startDateController;
  late TextEditingController _tenureController;

  double tempPrincipalAmount = 1000.0;
  double annualInterestRate = 8.0;
  String selectedTenure = 'Month';
  double emi = 0.0;
  double totalPayment = 0.0;
  double totalInterest = 0.0;
  bool showResult = false;
  DateTime? selectedStartDate;

  double _principalInputValue = 1000.0;
  int _tenureInputValue = 10;

  final List<String> tenureOptions = ['Month', 'Year']; // Tenure options

  @override
  void initState() {
    super.initState();

    _principalController = TextEditingController(text: tempPrincipalAmount.toString());
    _interestRateController = TextEditingController(text: annualInterestRate.toString());

    // Set default date to current date
    selectedStartDate = DateTime.now();
    _startDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(selectedStartDate!),
    );
    _tenureController = TextEditingController(text: _tenureInputValue.toString());
    calculateEMI();
    showResult = true;
  }

  void calculateEMI() {
    double principalAmount = tempPrincipalAmount;

    int tenure;
    if (selectedTenure == 'Month') {
      tenure = _tenureInputValue;
    } else {
      tenure = _tenureInputValue * 12;
    }

    double monthlyInterestRate = calculateMonthlyInterestRate(annualInterestRate);
    emi = (principalAmount * monthlyInterestRate * pow(1 + monthlyInterestRate, tenure)) /
        (pow(1 + monthlyInterestRate, tenure) - 1);
    totalPayment = emi * tenure;
    totalInterest = totalPayment - principalAmount;

    setState(() {
      showResult = true; // Show results after calculation
    });
  }

  double calculateMonthlyInterestRate(double rateOfInterest) {
    return rateOfInterest / (12 * 100); // Monthly rate as a decimal
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedStartDate) {
      setState(() {
        selectedStartDate = pickedDate;
        _startDateController.text = DateFormat('dd/MM/yyyy').format(selectedStartDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomMenuBar(),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width - 44.w,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(2.w),
            children: [
              BreadcrumbNavBar(
                breadcrumbItems: ['Home', 'Calculators', 'EMI Calculator'],
                routes: ['/', '/calculators', '/emi-calculator'],
                currentRoute: ModalRoute.of(context)?.settings.name ?? 'EMI Calculator',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "EMI Calculator",
                      style: TextStyle(
                          fontSize: 2.5.t,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      "EMI calculator is a digital tool that helps you calculate your loan EMI using multiple part payments like Monthly, quarterly, yearly, onetime only for the amount borrowed. It thus helps you find out your monthly EMI outgo and plan your loan prepayment properly.",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 1.1.t, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInputField(
                            controller: _principalController,
                            label: "Principal Amount (₹)",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is empty';
                              }
                              double? amount = double.tryParse(value);
                              if (amount == null || amount < 1000) {
                                return 'Principal amount must be at least ₹1,000';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _principalInputValue = double.tryParse(value) ?? 0; // Store user input here
                              });
                            },
                          ),
                          SizedBox(width: 1.w),
                          _buildInputField(
                            controller: _interestRateController,
                            label: "Interest Rate (%)",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is empty';
                              }
                              double? rate = double.tryParse(value);
                              if (rate == null || rate < 1) {
                                return 'Interest rate must be at least 1%';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                annualInterestRate = double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                          SizedBox(width: 1.w),
                          _buildDateField(
                            controller: _startDateController,
                            label: "Starting From",
                            onTap: () => _selectDate(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.w),
// Add the loan tenure dropdown on the next row
                      Row(
                        children: [
                          // Input field to allow users to enter the tenure (in months or years)
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 54.w, // Set the width to minimize the input field
                              child: TextFormField(
                                controller: _tenureController,
                                decoration: InputDecoration(
                                  labelText: "Enter Tenure",
                                  hintText: selectedTenure == 'Month'
                                      ? 'Enter months'
                                      : 'Enter years',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the tenure';
                                  }
                                  int? tenureValue = int.tryParse(value);
                                  if (tenureValue == null || tenureValue <= 0) {
                                    return 'Enter a valid tenure';
                                  }
                                  _tenureInputValue = tenureValue; // Update the tenure value
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _tenureInputValue = int.tryParse(value) ?? 1;
                                  });
                                },
                              ),
                            ),
                          ),

                          // Dropdown for selecting the tenure (Monthly or Yearly)
                          SizedBox(width: 2.w),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 54.w, // Set the width to minimize the dropdown
                              child: _buildDropdownField(
                                label: "Tenure Type",
                                value: selectedTenure,
                                items: tenureOptions,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTenure = newValue ?? selectedTenure;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            PartPaymentTable(),
              SizedBox(height: 5.w,),
              CalculateButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() {
                      tempPrincipalAmount = _principalInputValue; // Update tempPrincipalAmount only here
                      calculateEMI();
                      showResult = true;
                    });
                  }
                },
              ),
              SizedBox(height: 4.5.w),
              if (showResult)
                InvestmentResult(
                  principalAmount: double.parse(tempPrincipalAmount.toStringAsFixed(0)),
                  totalInterestEarned: double.parse(totalInterest.toStringAsFixed(0)), // Pass totalInterest as totalInterestEarned
                  maturityValue: double.parse(totalPayment.toStringAsFixed(0)), // Pass totalPayment as maturityValue
                ),


              SizedBox(height: 2.w),
            ],
          ),
        ),
      ),
    );
  }

  // Custom widget for input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required Function(String) onChanged,
  }) {
    return Flexible(
      flex: 1,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  // Custom widget for date input
  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return Flexible(
      flex: 1,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: onTap,
      ),
    );
  }

  // Custom widget for the tenure type dropdown
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Flexible(
      flex: 1,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: value,
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}




