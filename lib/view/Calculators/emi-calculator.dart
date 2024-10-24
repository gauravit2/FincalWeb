import 'package:fincalweb_project/controller/part_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fincalweb_project/components/emi_calculator_components/part_payment_table.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';
import 'package:fincalweb_project/helper/Calculate_button.dart';
import 'dart:math';
import 'package:fincalweb_project/components/emi_calculator_components/loan_detail_table.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:fincalweb_project/helper/showToast.dart';


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

  double tempPrincipalAmount = 10000.0;
  double annualInterestRate = 7.0;
  String selectedTenure = 'Month';
  double emi = 0.0;
  double totalPayment = 0.0;
  double totalInterest = 0.0;
  double totalPrinciple = 0.0;
  bool showResult = false;
  DateTime? selectedStartDate;

  int _tenureInputValue = 15;

  final List<String> tenureOptions = ['Month', 'Year'];
  List<LoanDetail> loanDetailList = <LoanDetail>[];
  final NumberFormat numberFormat = NumberFormat.decimalPattern('en_IN');
  var value;

  @override
  void initState() {
    super.initState();

    _principalController = TextEditingController(text: numberFormat.format(tempPrincipalAmount));
    _interestRateController = TextEditingController(text: annualInterestRate.toString());

    // Set default date to current date
    selectedStartDate = DateTime.now();
    _startDateController = TextEditingController(
      text: DateFormat('MMM yyyy').format(selectedStartDate!),
    );
    _tenureController = TextEditingController(text: _tenureInputValue.toString());

    _principalController.addListener(() {
      String text = _principalController.text.replaceAll(',', ''); // Remove existing commas
      if (text.isNotEmpty) {
        setState(() {
          _principalController.value = _principalController.value.copyWith(
            text: numberFormat.format(int.parse(text)),
            selection: TextSelection.collapsed(
                offset: numberFormat.format(int.parse(text)).length),
          );
        });
      }
      void _onTenureChanged(String value) {
        setState(() {
          _tenureInputValue = int.tryParse(value) ?? 15; // Default to 15 if input is invalid
        });
      }
    });


    // Calculate the EMI as soon as the widget is built
    calculateEMI();
    showResult = true; // Show results immediately
  }

  void calculateEMI() {
    double outstanding = double.tryParse(_principalController.text.replaceAll(',', '')) ?? tempPrincipalAmount;
    //double outstanding = double.tryParse(_principalController.text) ?? tempPrincipalAmount;
    double tenure = (selectedTenure == 'Month')
        ? _tenureInputValue.toDouble()
        : _tenureInputValue * 12;
    double roiPerMonth = calculateRateOfInterestPerMonth(annualInterestRate);
    double power = calculatePower(roiPerMonth, tenure);
    emi = calculateEmi(outstanding, roiPerMonth, power);
    print(
        "emi = $emi principle = $outstanding tenure = $tenure roi = $annualInterestRate");
    totalPrinciple = 0;
    totalPayment = 0;
    totalInterest = 0;
    loanDetailList.clear();
    DateTime currentDateTime = selectedStartDate!;
    for (int i = 0; i < tenure; i++) {
      double interest = calculateInterest(outstanding, roiPerMonth);
      double mPrinciple = 0;
      if (emi < outstanding) {
        mPrinciple = calculatePrinciple(emi, interest);
      } else {
        mPrinciple = outstanding;
      }
      double partPayment = 0.0;
      // double partPayment = calculatePartPayment(currentDateTime);
      if (emi > outstanding && partPayment != 0) {
        partPayment = 0;
        outstanding = outstanding - mPrinciple;
      } else {
        outstanding = calculateOutstanding(outstanding, mPrinciple);
        if (outstanding < partPayment) {
          partPayment = outstanding;
          outstanding = 0;
        } else
          outstanding -= partPayment;
      }
      LoanDetail loanDetail = LoanDetail(
          month: getMonth(currentDateTime),
          year: getYear(currentDateTime),
          principal: mPrinciple.toPrecision(0),
          interest: interest.toPrecision(0),
          partPayment: partPayment.toPrecision(0),
          outstanding: outstanding.toPrecision(0));
      loanDetailList.add(loanDetail);
      print("month = " +
          loanDetail.month +
          " year = " +
          loanDetail.year.toString() +
          " principle = " +
          loanDetail.principal.toStringAsFixed(0) +
          " interest = " +
          loanDetail.interest.toStringAsFixed(0) +
          " partPayment = " +
          loanDetail.partPayment.toStringAsFixed(0) +
          " totalPayment = " +
          loanDetail.totalPayment.toStringAsFixed(0) +
          " outstanding = " +
          loanDetail.outstanding.toStringAsFixed(0));
      currentDateTime =
          DateTime(currentDateTime.year, currentDateTime.month + 1);
      totalPrinciple = totalPrinciple + loanDetail.principal.toPrecision(0);
      totalInterest = totalInterest + loanDetail.interest.toPrecision(0);
      totalPayment = totalPayment + loanDetail.totalPayment;
    }
    print(
        "totalPrinciple = $totalPrinciple totalInterest = $totalInterest totalPayment = $totalPayment");

    setState(() {
      showResult = true; // Show results after calculation
    });
  }

  String getMonth(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  int getYear(DateTime date) {
    return date.year;
  }

  double calculatePower(double roiPerMonth, double tenure) {
    double power = pow(1 + roiPerMonth, tenure).toDouble();
    print("power = $power");
    return power;
  }

  double calculateEmi(double outstanding, double roiPerMonth, double power) {
    return (outstanding * roiPerMonth * power) / (power - 1);
  }

  double calculateMonthlyInterestRate(double rateOfInterest) {
    return rateOfInterest / (12 * 100);
  }

  double calculateRateOfInterestPerMonth(double rateOfInterest) {
    return (rateOfInterest / 12) / 100;
  }

  double calculateInterest(double outstanding, double roiPerMonth) {
    return outstanding * roiPerMonth;
  }

  double calculatePrinciple(double emi, double interest) {
    return emi - interest;
  }

  double calculateOutstanding(double outstanding, double principle) {
    return outstanding - principle;
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
            DateFormat('MMM yyyy').format(selectedStartDate!);
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
                        color: Colors.teal.shade800,
                      ),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      "EMI calculator is a digital tool that helps you calculate your loan EMI using multiple part payments like Monthly, quarterly, yearly, onetime only for the amount borrowed. It helps you to find out your monthly EMI easily and plan your loan repayment properly.",
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is empty.';
                              }
                              return null;
                            },


                            onSubmited: (value) {
                              double parsedValue = double.tryParse(value) ?? 0;
                              if (parsedValue <= 0) {
                                showToast(context, "Field is empty.", icon: Icons.error);
                              } else {
                                setState(() {
                                  tempPrincipalAmount = parsedValue;
                                });
                                showToast(context, "Field is empty.", icon: Icons.check_circle);
                                calculateEMI(); // Recalculate EMI after principal amount changes
                              }
                            },

                          ),

                          SizedBox(width: 1.w),
                          _buildInputField(
                            controller: _interestRateController,
                            label: "Interest Rate (%)",
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is empty.';
                              }
                              return null;
                            },
                            onSubmited: (value) {
                              double parsedValue = double.tryParse(value) ?? 0;
                              if (parsedValue <= 0) {
                                showToast(context, "Please enter a valid Interest Rate.", icon: Icons.error);
                              } else {
                                setState(() {
                                  annualInterestRate = parsedValue;
                                });
                                showToast(context, "Interest Rate updated to $parsedValue%.", icon: Icons.check_circle);
                                calculateEMI(); // Recalculate EMI after interest rate changes
                              }
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
                              width: 170,
                              child: TextFormField(
                                controller: _tenureController,
                                decoration: InputDecoration(
                                  labelText: "Enter Tenure",
                                  hintText: selectedTenure == 'Month' ? 'Enter months' : 'Enter years',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'field is empty.';
                                  }
                                  int? tenureValue = int.tryParse(value);
                                  if (tenureValue == null || tenureValue <= 0) {
                                    return 'Enter a valid tenure.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  int parsedValue = int.tryParse(value) ?? 0;
                                  if (parsedValue <= 0) {
                                    showToast(context, "Field is empty.", icon: Icons.error);
                                  } else {
                                    setState(() {
                                      _tenureInputValue = parsedValue;
                                    });
                                   // showToast(context, "Tenure updated to $parsedValue months.", icon: Icons.check_circle);
                                    calculateEMI(); // Recalculate EMI after tenure changes
                                  }
                                },
                              ),
                            ),
                          ),
                      SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 170,
                              child: DropdownButtonFormField<String>(
                                value: selectedTenure,
                                items: tenureOptions.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedTenure = newValue;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Tenure Type",
                                  border: OutlineInputBorder(),
                                ),
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
                          if (!_principalController.text.isEmpty && !_interestRateController.text.isEmpty && !_tenureController.text.isEmpty) {
                            setState(() {
                              LoanDetailTable.tableKey.currentState?.collapseAllRows();
                              tempPrincipalAmount = double.tryParse(_principalController.text) ?? 0.0;
                              annualInterestRate = double.tryParse(_interestRateController.text) ?? 0.0;
                              calculateEMI();
                              showResult = true;
                            });
                          }
                          else{
                            showToast(context,"Field is empty");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 0.w),
                          child: Container(
                            height: 7.w,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade200,
                            ),
                            child: Center(
                              child: Text(
                                "EMI : ₹ ${NumberFormat('#,##,###').format(emi)}",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30.w,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.green,
                                      value: totalPrinciple,
                                      title: '',
                                      radius: 42,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.orangeAccent,
                                      value: totalInterest,
                                      title: '',
                                      radius: 42,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.blue,
                                      value: double.tryParse(controller.partPaymentValue.value) ?? 0.0,
                                      title: '',
                                      radius: 42,
                                    ),
                                  ],
                                  centerSpaceRadius: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 150,
                                padding: EdgeInsets.all(12),
                                color: Colors.grey.shade50,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Principal Amount'),
                                        Spacer(),
                                        Text('₹ ${numberFormat.format(totalPrinciple)}'),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text('Interest Rate'),
                                        Spacer(),
                                        Text('₹ ${numberFormat.format(totalInterest)}'),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text('Part payment'),
                                        Spacer(),
                                        Text('₹ ${numberFormat.format(double.parse(controller.partPaymentValue.value))}'),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Divider(),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text('Total Amount'),
                                        Spacer(),
                                        Text('₹ ${numberFormat.format(totalPayment)}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Container(
                              width: 40.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                color: Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.teal.shade800),
                              ),
                              child: Center(
                                child: Text(
                                  "Ad",
                                  style: TextStyle(
                                    fontSize: 2.5.t,
                                    color: Colors.teal.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  LoanDetailTable(
                    key: LoanDetailTable.tableKey,
                    loanDetailList: loanDetailList,
                    tenureInputValue: _tenureInputValue,
                  ),
                ],
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
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onSubmited,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: (value) {
          final errorMessage = validator?.call(value);
          if (errorMessage != null) {
            showToast(context, "Field is empty"); // Show toast for validation error
          }
          return errorMessage;
        },
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
    required Function(String?) onSubmitted,
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
        onChanged: onSubmitted,
      ),
    );
  }
}
