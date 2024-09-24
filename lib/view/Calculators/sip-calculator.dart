import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fincalweb_project/helper/Calculate_button.dart';
import 'package:fincalweb_project/helper/InvestmentResult.dart';
import 'dart:math';

class SipCalculator extends StatefulWidget {
  const SipCalculator({super.key});

  @override
  _SipCalculatorState createState() => _SipCalculatorState();
}

class _SipCalculatorState extends State<SipCalculator> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  late TextEditingController _interestRateController;
  late TextEditingController _durationController;

  double investedAmount = 2000.0; // Initialize with minimum
  double annualInterestRate = 8.0; // Sample ROI
  int tenure = 5; // Example tenure
  double tempPrincipalAmount = 2000.0;
  double maturityAmount = 0.0;
  double totalInvestmentAmount = 0.0;
  double totalInterestEarned = 0.0;
  bool showResult = false;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(text: investedAmount.toString());
    _interestRateController = TextEditingController(text: annualInterestRate.toString());
    _durationController = TextEditingController(text: tenure.toString());

    calculateSIP();
    showResult = true;
  }

  void calculateSIP() {
    double roi = calculateRateOfInterestPerMonth(annualInterestRate);
    double power = calculatePowerInMonths(roi, tenure);
    maturityAmount = investedAmount * ((power - 1) / roi) * (1 + roi);
    totalInvestmentAmount = investedAmount * tenure * 12;
    totalInterestEarned = maturityAmount - totalInvestmentAmount;
  }

  double calculateRateOfInterestPerMonth(double rateOfInterest) {
    return rateOfInterest / (12 * 100); // Monthly rate
  }

  double calculatePowerInMonths(double roi, int tenureYears) {
    int months = tenureYears * 12;
    return pow(1 + roi, months).toDouble(); // Explicitly convert to double
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
                breadcrumbItems: ['Home', 'Calculators', 'SIP Calculator'],
                routes: ['/', '/get-started', '/sip-calculator'],
                currentRoute: ModalRoute.of(context)?.settings.name ?? 'SIP Calculator',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "SIP Calculator",
                      style: TextStyle(
                          fontSize: 2.5.t,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      "A systematic investment plan (SIP) calculator is a simple tool that allows individuals to get an idea of the returns on their mutual fund investments made through SIP. SIP investments in mutual funds have become one of the most popular investment options nowadays.",
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInputField(
                        controller: _amountController,
                        label: "Investment Amount (₹)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is empty';
                          }
                          double? amount = double.tryParse(value);
                          if (amount == null || amount < 500) {
                            return 'Investment amount must be at least ₹500';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            tempPrincipalAmount = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(width: 2.w),
                      _buildInputField(
                        controller: _durationController,
                        label: "Time Period (Years)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is empty';
                          }
                          int? duration = int.tryParse(value);
                          if (duration == null || duration < 1) {
                            return 'Time period must be at least 1 year';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            tenure = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(width: 2.w),
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
                    ],
                  ),
                ),
              ),
              CalculateButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() {
                      investedAmount = tempPrincipalAmount;
                      calculateSIP();
                      showResult = true;
                    });
                  }
                },
              ),
              SizedBox(height: 4.5.w),
              if (showResult)
                InvestmentResult(
                  principalAmount: double.parse(investedAmount.toStringAsFixed(0)),
                  totalInterestEarned: double.parse(totalInterestEarned.toStringAsFixed(0)),
                  maturityValue: double.parse(maturityAmount.toStringAsFixed(0)),
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
    required String? Function(String?) validator,
    required void Function(String) onChanged,
  }) {
    return Expanded(
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
}
