import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fl_chart/fl_chart.dart';

class PpfCalculator extends StatefulWidget {
  const PpfCalculator({super.key});

  @override
  _PpfCalculatorState createState() => _PpfCalculatorState();
}

class _PpfCalculatorState extends State<PpfCalculator> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to hold initial values in text fields
  late TextEditingController _amountController;
  late TextEditingController _interestRateController;
  late TextEditingController _durationController;

  double investedAmount = 500.0; // Default investment amount
  double annualInterestRate = 7.1; // Default interest rate
  int tenureInYears = 15; // Default tenure

  double maturityValue = 0.0;
  double totalInterestEarned = 0.0;
  bool showResult = false; // Flag to control the display of the result section

  @override
  void initState() {
    super.initState();

    // Initializing controllers with default values
    _amountController = TextEditingController(text: investedAmount.toString());
    _interestRateController = TextEditingController(text: annualInterestRate.toString());
    _durationController = TextEditingController(text: tenureInYears.toString());

    // Automatically calculate the PPF when the app starts
    calculatePPF();
    showResult = true; // Show the result initially
  }
  double totalInvestmentAmount = 0.0;

  void calculatePPF() {

    double tenure = tenureInYears.toDouble();


    double roi = calculateRateOfInterestPerYear(annualInterestRate);

    // Calculate the compound factor (casting tenure to double)
    double power = calculatePower(roi, tenure);

    // Calculate the maturity amount
    double maturityAmount = investedAmount * ((power - 1) / roi) * (1 + roi);

    // Total investment amount
    totalInvestmentAmount = investedAmount * tenure;

    // Total interest earned
    double totalInterestEarned = maturityAmount - totalInvestmentAmount;

    setState(() {
      this.maturityValue = maturityAmount;
      this.totalInterestEarned = totalInterestEarned;
    });
  }

  // Math helper method for calculating compound power
  double calculatePower(double rateOfInterest, double tenure) {
    return pow(1 + rateOfInterest, tenure).toDouble(); // Cast num to double
  }

  // Math helper method to calculate rate of interest per year
  double calculateRateOfInterestPerYear(double rateOfInterest) {
    return rateOfInterest / 100;
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
                breadcrumbItems: ['Home', 'Calculators', 'PPF Calculator'],
                routes: ['/', '/get_started', '/PPF_calculator'],
                currentRoute: ModalRoute.of(context)?.settings.name ?? 'PPF Calculator',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "PPF Calculator",
                      style: TextStyle(
                          fontSize: 2.5.t,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      "Public Provident Fund (PPF) is a long-term investment scheme by the Government of India.",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 1.5.t, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.w),
                child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInputField(
                        controller: _amountController,
                        label: "Investment Amount (₹)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          double? amount = double.tryParse(value);
                          if (amount == null || amount < 500 || amount > 1500) {
                            return 'Amount should be between ₹500 and ₹1500';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            investedAmount = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      _buildInputField(
                        controller: _interestRateController,
                        label: "Interest Rate(%)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the interest rate';
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
                      _buildInputField(
                        controller: _durationController,
                        label: "Time Period(Years)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the tenure';
                          }
                          int? years = int.tryParse(value);
                          if (years == null || years < 15 || years > 50) {
                            return 'Tenure must be between 15 and 50 years';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            tenureInYears = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        calculatePPF(); // Final calculation when user clicks Calculate
                        showResult = true; // Show result after calculation
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 2.w),
                  ),
                  child: Text(
                    'Calculate',
                    style: TextStyle(fontSize: 1.5.t, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              if (showResult) // Only display when the flag is true
                Column(
                  children: [
                    Divider(thickness: 2, color: Colors.teal),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: Text(
                        "Investment result",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 2.5.t,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.w,
                          width: 70.w,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: investedAmount,
                                  title: investedAmount.toStringAsFixed(2),
                                  radius: 35,
                                  titleStyle: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                                PieChartSectionData(
                                  color: Colors.orangeAccent,
                                  value: totalInterestEarned,
                                  title: totalInterestEarned.toStringAsFixed(2),
                                  radius: 35,
                                  titleStyle: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                                PieChartSectionData(
                                  color: Colors.blueAccent,
                                  value: maturityValue,
                                  title: maturityValue.toStringAsFixed(2),
                                  radius: 35,
                                  titleStyle: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            _buildInvestmentDetail("Investment Amount", totalInvestmentAmount),
                            _buildInvestmentDetail("Interest Amount", totalInterestEarned),
                            _buildInvestmentDetail("Maturity Amount", maturityValue),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),
                    Container(
                      height: 30.w,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "AD",
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      width: 28.w,
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

  Widget _buildInvestmentDetail(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        children: [
          Icon(
            Icons.square,
            size : 30,
            color: label == "Investment Amount"
                ? Colors.green
                : label == "Interest Amount"
                ? Colors.orangeAccent
                : Colors.blueAccent,
          ),
          SizedBox(width: 1.w),
          Text(
            "$label:  ₹ ${value.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 1.6.t),
          ),
        ],
      ),
    );
  }
}
