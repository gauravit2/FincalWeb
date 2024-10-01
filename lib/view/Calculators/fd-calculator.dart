import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fincalweb_project/helper/Calculate_button.dart';
import 'package:fincalweb_project/helper/InvestmentResult.dart'; // Import the InvestmentResult

class FdCalculator extends StatefulWidget {
  const FdCalculator({super.key});

  @override
  _FdCalculatorState createState() => _FdCalculatorState();
}

class _FdCalculatorState extends State<FdCalculator> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _principalController;
  late TextEditingController _interestRateController;
  late TextEditingController _durationController;

  double principalAmount = 25000.0; // This only updates when the user clicks Calculate
  double annualInterestRate = 6.5;
  int durationInYears = 10;

  // Temporary variable to hold the user input, which changes dynamically
  double tempPrincipalAmount = 25000.0;

  double maturityValue = 0.0;
  double totalInterestEarned = 0.0;
  bool showResult = false;

  @override
  void initState() {
    super.initState();

    _principalController = TextEditingController(text: tempPrincipalAmount.toString());
    _interestRateController = TextEditingController(text: annualInterestRate.toString());
    _durationController = TextEditingController(text: durationInYears.toString());

    calculateFD();
    showResult = true;
  }

  void calculateFD() {
    double r = annualInterestRate;
    double t = durationInYears.toDouble();

    maturityValue = principalAmount + (principalAmount * r * t / 100);
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
                routes: ['/', '/calculators', '/fd-calculator'],
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
                        controller: _principalController,
                        label: "Investment Amount (₹)",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Feild is empty';
                          }
                          double? amount = double.tryParse(value);
                          if (amount == null || amount < 5000) {
                            return 'Minimum investment amount allowed is 5000';
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
                            durationInYears = int.tryParse(value) ?? 0;
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
                      principalAmount = tempPrincipalAmount;
                      calculateFD();
                      showResult = true;
                    });
                  }
                },

              ),
              SizedBox(height: 4.5.w),
              if (showResult)
                InvestmentResult(
                  principalAmount: double.parse(principalAmount.toStringAsFixed(0)),
                  totalInterestEarned: double.parse(totalInterestEarned.toStringAsFixed(0)),
                  maturityValue: double.parse(maturityValue.toStringAsFixed(0)),
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
