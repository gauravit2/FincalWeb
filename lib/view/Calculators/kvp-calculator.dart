import 'package:fincalweb_project/helper/InvestmentResult.dart';
import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../helper/Calculate_button.dart';

class KvpCalculator extends StatefulWidget {
  const KvpCalculator({super.key});

  @override
  _KvpCalculatorState createState() => _KvpCalculatorState();
}

class _KvpCalculatorState extends State<KvpCalculator> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to hold initial values in text fields
  late TextEditingController _amountController;
  late TextEditingController _interestRateController;
  late TextEditingController _durationController;

  double investedAmount = 10000.0; // Default investment amount
  double maturityAmount = 0.0;
  double totalInterestEarned = 0.0;
  double tempPrincipalAmount = 20000.0;
  double annualInterestRate = 7.5;
  int tenureInYears = 9;
  bool showResult = false;

  @override
  void initState() {
    super.initState();

    // Initializing controllers with default values
    _amountController = TextEditingController(text: investedAmount.toString());
    _interestRateController =
        TextEditingController(text: annualInterestRate.toString());
    _durationController = TextEditingController(text: tenureInYears.toString());

    // Automatically calculate the KVP when the app starts
    calculateKVP();
    showResult = true; // Show the result initially
  }

  void calculateKVP() {
    // Calculate the maturity amount (KVP doubles the investment)
    double maturityAmount = investedAmount * 2;

    // Calculate total interest earned
    double totalInterestEarned = maturityAmount - investedAmount;

    setState(() {
      this.maturityAmount = maturityAmount;
      this.totalInterestEarned = totalInterestEarned;
    });
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
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width - 44.w,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(2.w),
            children: [
              BreadcrumbNavBar(
                breadcrumbItems: ['Home', 'Calculators', 'KVP Calculator'],
                routes: ['/', '/calculators', '/kvp-calculator'],
                currentRoute: ModalRoute.of(context)?.settings.name ?? 'KVP Calculator',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "KVP Calculator",
                      style: TextStyle(
                          fontSize: 2.5.t,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      "This is Kisan Vikas Patra (KVP) calculator used to plan long term investment plan. The primary purpose of KVP scheme was to introduce long-termfinancial planning concepts to the public",
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
                          if (amount == null || amount < 1000 || amount > 1000000) {
                            return 'Minimum investment amount allowed is 1000 and maximum is 10,00,000 ';
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
                            return 'Feild is empty';
                          }
                          int? duration = int.tryParse(value);
                          if (duration == null || duration < 1) {
                            return 'Time period must be at least 1 year';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            tenureInYears = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(width: 2.w),
                      _buildInputField(
                        controller: _interestRateController,
                        label: "Interest Rate(%)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Feild is empty';
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
                      calculateKVP();
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
