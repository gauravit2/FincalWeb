import 'package:fincalweb_project/controller/part_payment_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class PartPayment {
  final double principleAmount;
  final String month;
  final int year;
  final double principal;
  final double interest;
  final double partPayment;
  double outstanding;
  final PartPaymentController controller = Get.find<PartPaymentController>();

  PartPayment({
    required this.month,
    required this.year,
    required this.principal,
    required this.interest,
    required this.partPayment,
    required this.outstanding,
    required this.principleAmount,
  });

  double get totalPayment =>
      principal + interest + partPayment; // Compute on demand
}

late TextEditingController _principalController;
late TextEditingController _interestRateController;
late TextEditingController _startDateController;
late TextEditingController _tenureController;

double tempPrincipalAmount = 2000.0;
double annualInterestRate = 8.0;
String selectedTenure = 'Month';
double totalPayment = 0.0;
double totalInterest = 0.0;
double partPayment = 0.0;
bool showResult = false;
DateTime? selectedStartDate;

double _principalInputValue = 2000.0;
int _tenureInputValue = 10;

final List<String> tenureOptions = ['Month', 'Year'];

var value;

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

double calculatePartPayment(
    int month, int year, List<PartPayment> partPayments) {
  for (PartPayment payment in partPayments) {
    if (int.parse(payment.month) == month && payment.year == year) {
      return payment.partPayment;
    }
  }
  return 0.0; // Ensure this is a double
}

class PaymentTable extends StatefulWidget {
  final double principleAmount;
  final String tenureType;
  final double tenure;

  const PaymentTable({
    required this.principleAmount,
    required this.tenureType,
    required this.tenure,
  });

  @override
  _PaymentTableState createState() => _PaymentTableState();
}

class _PaymentTableState extends State<PaymentTable> {
  Map<int, bool> yearExpandedMap = {};
  List<PartPayment> paymentSchedule = [];
  Map<int, double> totalPrincipalMap = {};
  Map<int, double> totalInterestMap = {};
  Map<int, double> totalPartPaymentMap = {};
  Map<int, double> totalOutstandingMap = {};

  @override
  void initState() {
    super.initState();
    double tenureInMonths =
        widget.tenureType == "years" ? widget.tenure * 12 : widget.tenure;

    _principalController =
        TextEditingController(text: tempPrincipalAmount.toString());
    _interestRateController =
        TextEditingController(text: annualInterestRate.toString());
    selectedStartDate = DateTime.now();
    _startDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(selectedStartDate!),
    );
    _tenureController =
        TextEditingController(text: _tenureInputValue.toString());

    paymentSchedule = generatePaymentSchedule(
      widget.principleAmount,
      7.0, // Annual Interest Rate
      tenureInMonths,
      [], // Empty part payment list for simplicity
    );

    for (PartPayment payment in paymentSchedule) {
      int year = payment.year;
      totalPrincipalMap[year] =
          (totalPrincipalMap[year] ?? 0) + payment.principal;
      totalInterestMap[year] = (totalInterestMap[year] ?? 0) + payment.interest;
      totalPartPaymentMap[year] =
          (totalPartPaymentMap[year] ?? 0) + payment.partPayment;
      totalOutstandingMap[year] = payment.outstanding;
      yearExpandedMap[year] = false;
    }

    calculateEMI();
  }

  void calculateEMI() {
    double outstanding =
        double.tryParse(_principalController.text) ?? tempPrincipalAmount;
    double tenure = (selectedTenure == 'Month')
        ? _tenureInputValue.toDouble()
        : _tenureInputValue * 12;
    double roiPerMonth = calculateRateOfInterestPerMonth(annualInterestRate);
    double power = calculatePower(roiPerMonth, tenure);
    double emi = calculateEmi(outstanding, roiPerMonth, power);

    print(
        "emi = $emi principle = $outstanding tenure = $tenure roi = $annualInterestRate");

    totalPayment = emi * tenure;
    totalInterest = totalPayment - outstanding;

    setState(() {
      showResult = true; // Show results after calculation
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrincipal =
        paymentSchedule.fold(0.0, (sum, item) => sum + item.principal);
    double totalInterest =
        paymentSchedule.fold(0.0, (sum, item) => sum + item.interest);
    double totalPartPayment =
        paymentSchedule.fold(0.0, (sum, item) => sum + item.partPayment);
    double totalOutstanding =
        paymentSchedule.isNotEmpty ? paymentSchedule.last.outstanding : 0.0;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: Table(
          border: TableBorder.all(
            color: Colors.teal.shade300,
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.5),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2.5),
            5: FlexColumnWidth(2),
          },
          children: [
            _buildHeaderRow(),
            ..._buildExpandableRows(),
            _buildTotalsRow(totalPrincipal, totalInterest, totalPartPayment),
          ],
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.teal.shade600),
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Text('Year', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Text('Principal', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Text('Interest', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child:
                  Text('Part Payment', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child:
                  Text('Total Payment', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child:
                  Text('Outstanding', style: TextStyle(color: Colors.white))),
        ),
      ],
    );
  }

  List<TableRow> _buildExpandableRows() {
    List<TableRow> rows = [];
    Set<int> years = paymentSchedule.map((p) => p.year).toSet();

    for (int year in years) {
      rows.add(
        _buildExpandableRow(
          year.toString(),
          yearExpandedMap[year]!,
          totalPrincipalMap[year]!,
          totalInterestMap[year]!,
          totalPartPaymentMap[year]!,
          totalOutstandingMap[year]!,
        ),
      );

      if (yearExpandedMap[year]!) {
        List<PartPayment> yearPayments =
            paymentSchedule.where((p) => p.year == year).toList();
        rows.addAll(yearPayments.map((p) => _buildDataRow(
              '  ${p.month}',
              p.principal,
              p.interest,
              p.partPayment,
              p.totalPayment,
              p.outstanding,
              Colors.white,
            )));
      }
    }

    return rows;
  }

  TableRow _buildExpandableRow(
      String year,
      bool isExpanded,
      double principalTotal,
      double interestTotal,
      double partPaymentTotal,
      double outstandingTotal) {
    return TableRow(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              yearExpandedMap[int.parse(year)] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.teal.shade100,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(year),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
        ),
        _buildDataCell(principalTotal),
        _buildDataCell(interestTotal),
        _buildDataCell(partPaymentTotal),
        _buildDataCell(principalTotal + interestTotal + partPaymentTotal),
        _buildDataCell(outstandingTotal),
      ],
    );
  }

  TableRow _buildDataRow(
      String month,
      double principal,
      double interest,
      double partPayment,
      double totalPayment,
      double outstanding,
      Color bgColor) {
    return TableRow(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: bgColor,
            child: Center(child: Text(month))),
        _buildDataCell(principal),
        _buildDataCell(interest),
        _buildDataCell(partPayment),
        _buildDataCell(totalPayment),
        _buildDataCell(outstanding),
      ],
    );
  }

  Widget _buildDataCell(double value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(value.toStringAsFixed(0))),
    );
  }

  TableRow _buildTotalsRow(
      double totalPrincipal, double totalInterest, double totalPartPayment) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.teal.shade100),
      children: [
        const Center(child: Text('Total')),
        _buildDataCell(totalPrincipal),
        _buildDataCell(totalInterest),
        _buildDataCell(totalPartPayment),
        _buildDataCell(totalPrincipal + totalInterest + totalPartPayment),
        _buildDataCell(paymentSchedule.last.outstanding),
      ],
    );
  }

  List<PartPayment> generatePaymentSchedule(
      double principalAmount,
      double annualInterestRate,
      double tenureInMonths,
      List<PartPayment> partPayments) {
    List<PartPayment> paymentSchedule = [];
    double outstanding = principalAmount;

    // Calculate EMI
    double emi = calculateEmi(
      principalAmount,
      calculateRateOfInterestPerMonth(annualInterestRate),
      calculatePower(
          calculateRateOfInterestPerMonth(annualInterestRate), tenureInMonths),
    );

    // Start date for the payment schedule
    DateTime startDate = selectedStartDate ?? DateTime.now();

    for (int i = 0; i < tenureInMonths; i++) {
      // Calculate interest, principal, and part payment
      double interest = calculateInterest(
          outstanding, calculateRateOfInterestPerMonth(annualInterestRate));
      double principal = calculatePrinciple(emi, interest);
      double partPayment = calculatePartPayment(
          (i % 12) + 1, startDate.year + (i ~/ 12), partPayments);

      // Update the outstanding balance after principal and part payment deductions
      outstanding = calculateOutstanding(outstanding, principal + partPayment);

      // Handle the current month and year
      DateTime currentDate = startDate.add(Duration(days: i * 30));
      String currentMonth = getMonth(currentDate);
      int currentYear = currentDate.year;

      // Create a new PartPayment entry for this month
      PartPayment payment = PartPayment(
        month: currentMonth,
        year: currentYear,
        principal: principal,
        interest: interest,
        partPayment: partPayment,
        outstanding: outstanding,
        principleAmount: principalAmount,
      );

      // Add the payment for this month to the schedule
      paymentSchedule.add(payment);
    }

    return paymentSchedule;
  }
}
