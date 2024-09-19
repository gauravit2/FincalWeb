import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fl_chart/fl_chart.dart';

class FdCalculator extends StatefulWidget {
  const FdCalculator({super.key});

  @override
  _FdCalculatorState createState() => _FdCalculatorState();
}

class _FdCalculatorState extends State<FdCalculator> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to hold initial values in text fields
  late TextEditingController _principalController;
  late TextEditingController _interestRateController;
  late TextEditingController _durationController;

  double principalAmount = 50000.0; // Default principal amount
  double annualInterestRate = 6.5; // Default interest rate
  int durationInYears = 10; // Default duration

  double maturityValue = 0.0;
  double totalInterestEarned = 0.0;
  bool showResult = false; // Flag to control the display of the result section

  @override
  void initState() {
    super.initState();

    // Initializing controllers with default values
    _principalController = TextEditingController(text: principalAmount.toString());
    _interestRateController = TextEditingController(text: annualInterestRate.toString());
    _durationController = TextEditingController(text: durationInYears.toString());

    // Automatically calculate the FD when the app starts
    calculateFD();
    showResult = true; // Show the result initially
  }

  // FD Calculation using Simple Interest formula
  void calculateFD() {
    double r = annualInterestRate; // Rate of interest (Already in %)
    double t = durationInYears.toDouble(); // Time in years

    // Simple Interest Formula: Maturity Amount = P + (P * R * T / 100)
    maturityValue = principalAmount + (principalAmount * r * t / 100);

    // Total interest earned
    totalInterestEarned = maturityValue - principalAmount;
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
                breadcrumbItems: ['Home', 'Calculators', 'FD Calculator'],
                routes: ['/', '/get_started', '/FD_calculator'],
                currentRoute: ModalRoute.of(context)?.settings.name ?? 'FD Calculator',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "FD Calculator",
                      style: TextStyle(
                          fontSize: 2.5.t,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      "An FD calculator can be used to determine the interest and the amount that it will accrue at the time of maturity.",
                      textAlign: TextAlign.center,
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
                        controller: _principalController,
                        label: "Investment Amt (₹)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          double? amount = double.tryParse(value);
                          if (amount == null || amount < 5000) {
                            return 'Minimum amount is ₹5000';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            principalAmount = double.tryParse(value) ?? 0;
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
                          if (years == null || years < 1 || years > 25) {
                            return 'Tenure must be between 1 and 25 years';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            durationInYears = int.tryParse(value) ?? 0;
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
                        calculateFD(); // Final calculation when user clicks Calculate
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
                    style: TextStyle(fontSize: 1.5.t,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 2.h,),
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
                                  value: principalAmount,
                                  title: principalAmount.toStringAsFixed(2),
                                  radius: 35,
                                  titleStyle: TextStyle(fontSize: 12,  color: Colors.black),
                                ),
                                PieChartSectionData(
                                  color: Colors.orangeAccent,
                                  value: totalInterestEarned,
                                  title: totalInterestEarned.toStringAsFixed(2),
                                  radius: 35,
                                  titleStyle: TextStyle(fontSize: 12,  color: Colors.black),
                                ),
                                PieChartSectionData(
                                  color: Colors.blueAccent,
                                  value: maturityValue,
                                  title: maturityValue.toStringAsFixed(2),
                                  radius: 35,
                                  titleStyle: TextStyle(fontSize: 12,  color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            _buildInvestmentDetail("Investment Amount", principalAmount),
                            _buildInvestmentDetail("Interest Amount", totalInterestEarned),
                            _buildInvestmentDetail("Maturity Amount", maturityValue),
                          ],
                        ),
                      ],
                    ),
                    // Ad section moved below the pie chart and investment details
                    SizedBox(height: 8.w),
                    Container(
                      height: 30.w,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.teal.shade800),
                      ),
                      child: Center(
                        child: Text(
                          "Ad",
                          style: TextStyle(fontSize: 2.t, color: Colors.teal.shade700),
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

  // Input Field Widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required Function(String) onChanged,
  }) {
    return Container(
      width: 20.w,
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Investment detail text widget
  Widget _buildInvestmentDetail(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        children: [
          Icon(
            Icons.square,
            size: 30,
            color: label == "Investment Amount"
                ? Colors.green
                : label == "Interest Amount"
                ? Colors.orange
                : Colors.blue,  // Maturity Amount will be in blue
          ),
          SizedBox(width: 2.w),
          Text(
            "$label: ₹ ${value.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 1.5.t, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
