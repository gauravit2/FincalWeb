import 'package:fincalweb_project/controller/part_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fincalweb_project/components/emi_calculator_components/partpayment_table.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fincalweb_project/helper/Calculate_button.dart';
import 'dart:math';
import 'package:fincalweb_project/components/emi_calculator_components/table.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class EmiCalculator extends StatefulWidget {
  EmiCalculator({super.key});

  final PartPaymentController controller = Get.find<PartPaymentController>();

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
  double partPayment = 500.0;
  bool showResult = false;
  DateTime? selectedStartDate;

  double _principalInputValue = 1000.0;
  int _tenureInputValue = 10;

  final List<String> tenureOptions = ['Month', 'Year'];

  var value;

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
    _tenureController =
        TextEditingController(text: _tenureInputValue.toString());

    // Calculate the EMI as soon as the widget is built
    calculateEMI();
    showResult = true; // Show results immediately
  }

  void calculateEMI() {
    // Parse the principal amount from the controller's text
    double principalAmount =
        double.tryParse(_principalController.text) ?? tempPrincipalAmount;

    int tenure;
    if (selectedTenure == 'Month') {
      tenure = _tenureInputValue;
    } else {
      tenure = _tenureInputValue * 12;
    }

    double monthlyInterestRate =
    calculateMonthlyInterestRate(annualInterestRate);
    emi = (principalAmount *
        monthlyInterestRate *
        pow(1 + monthlyInterestRate, tenure)) /
        (pow(1 + monthlyInterestRate, tenure) - 1);
    totalPayment = emi * tenure;
    totalInterest = totalPayment - principalAmount;

    setState(() {
      showResult = true; // Show results after calculation
    });
  }

  double calculateMonthlyInterestRate(double rateOfInterest) {
    return rateOfInterest / (12 * 100);
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
        _startDateController.text =
            DateFormat('dd/MM/yyyy').format(selectedStartDate!);
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
                currentRoute:
                ModalRoute.of(context)?.settings.name ?? 'EMI Calculator',
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
                            onSubmited: (value) {
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
                            onSubmited: (value) {
                              setState(() {
                                annualInterestRate =
                                    double.tryParse(value) ?? 0;
                                calculateEMI(); // Recalculate EMI when the interest rate changes
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
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 54
                                  .w, // Set the width to minimize the input field
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
                                  _tenureInputValue =
                                      tenureValue; // Update the tenure value
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _tenureInputValue =
                                        int.tryParse(value) ?? 1;
                                    calculateEMI(); // Recalculate EMI when the tenure changes
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 54.w,
                              child: _buildDropdownField(
                                label: "Tenure Type",
                                value: selectedTenure,
                                items: tenureOptions,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTenure = newValue ?? selectedTenure;
                                    calculateEMI(); // Recalculate EMI when the tenure type changes
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.w),
                      PartPaymentTable(),
                      SizedBox(height: 5.w),
                      CalculateButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              // Update tempPrincipalAmount with the new input
                              tempPrincipalAmount =
                                  double.tryParse(_principalController.text) ??
                                      0.0;
                              calculateEMI(); // Recalculate EMI with the updated principal amount
                              showResult =
                              true; // Show results after calculation
                            });
                          }
                        },
                      ),
                      SizedBox(height: 5.w),
                      Column(
                        // Start directly with Column
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Investment result header
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 50.w),
                                  child: Container(
                                    height: 7.w,
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade200,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "EMI : ",
                                        style: TextStyle(
                                          fontSize: 2.t,
                                          color: Colors.teal.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5.w),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align pie chart and details
                            children: [
                              // Pie chart section
                              SizedBox(
                                height: 30.w,
                                width: 35.w, // Adjusted pie chart size
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        color: Colors.green,
                                        value:
                                        tempPrincipalAmount, // Principal Amount
                                        title: '', // No titles in the slices
                                        radius: 35,
                                      ),
                                      PieChartSectionData(
                                        color: Colors.orangeAccent,
                                        value: totalInterest, // Interest Amount
                                        title: '',
                                        radius: 35,
                                      ),
                                      PieChartSectionData(
                                        color: Colors.blue,
                                        value: double.tryParse(controller
                                            .partPaymentValue.value) ??
                                            0.0, // Interest Amount
                                        title: '',
                                        radius: 35,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                  width:
                                  8.w), // Space between pie chart and table

                              // Table section for investment details
                              Container(
                                width: 400,
                                height: 145,
                                padding: EdgeInsets.all(12),
                                color: Colors.grey.shade100,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.green),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text('Principle Amount'),
                                        Spacer(),
                                        Text(tempPrincipalAmount.toStringAsFixed(0)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.orange),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Interest Rate'),
                                        Spacer(),
                                        Text(totalInterest.toStringAsFixed(0)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.blue),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Part payment'),
                                        Spacer(),
                                        Text(controller.partPaymentValue.value)
                                      ],
                                    ),

                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.blue.shade800),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Total Amount'),
                                        Spacer(),
                                        Text(totalPayment.toStringAsFixed(0)),
                                      ],
                                    ),
                                    // Increase distance between the table and ad
                                    SizedBox(width: 20.w),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15.w), // ad container
                              Container(
                                width: 40.w, // Increased width for the ad
                                height: 30.w, // Increased height for the ad
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                  Border.all(color: Colors.teal.shade800),
                                ),
                                child: Center(
                                  child: Text(
                                    "Ad",
                                    style: TextStyle(
                                        fontSize: 2.5.t,
                                        color: Colors.teal.shade700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          PaymentTable(
                            principleAmount: _principalController.text.isEmpty ? 0.0 : double.parse(_principalController.text.trim()),
                            tenureType: selectedTenure,
                            tenure: _tenureInputValue.toDouble(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
    required Function(String) onSubmited,
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
        onFieldSubmitted: onSubmited,
      ),
    );
  }

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
