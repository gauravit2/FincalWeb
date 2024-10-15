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

  double get totalPayment => principal + interest + partPayment; // Compute on demand
}

// Function to generate the payment schedule
List<PartPayment> generatePaymentSchedule(
    double principal, double annualInterestRate, double tenureInMonths, List<PartPayment> partPayments) {
  double roiPerMonth = (annualInterestRate / 12) / 100;
  double emi = calculateEMI(principal, roiPerMonth, tenureInMonths);
  double outstanding = principal;
  List<PartPayment> paymentSchedule = [];

  DateTime currentDate = DateTime.now();

  for (int i = 0; i < tenureInMonths; i++) {
    String month = DateFormat('MMM').format(currentDate);
    int year = currentDate.year;

    double interest = calculateInterest(outstanding, roiPerMonth);
    double principalPortion = emi < outstanding ? calculatePrincipal(emi, interest) : outstanding;
    double partPayment = calculatePartPayment(currentDate.month, year, partPayments);

    outstanding = calculateOutstanding(outstanding, principalPortion);
    if (outstanding < partPayment) {
      partPayment = outstanding;
      outstanding = 0;
    } else {
      outstanding -= partPayment;
    }

    // Debugging statement to check values before adding to payment schedule
    print("Month: $month, Year: $year, Principal: $principalPortion, Interest: $interest, Part Payment: $partPayment, Outstanding: $outstanding");

    paymentSchedule.add(
      PartPayment(
        principleAmount: principal,
        month: month,
        year: year,
        principal: principalPortion,
        interest: interest,
        partPayment: partPayment,
        outstanding: outstanding,
      ),
    );

    if (outstanding <= 0) break;

    currentDate = DateTime(currentDate.year, currentDate.month + 1);
  }

  return paymentSchedule;
}

double calculateEMI(double principal, double roiPerMonth, double tenureInMonths) {
  double power = pow(1 + roiPerMonth, tenureInMonths).toDouble();
  return (principal * roiPerMonth * power) / (power - 1);
}

double calculateInterest(double outstanding, double roiPerMonth) {
  return outstanding * roiPerMonth;
}

double calculatePrincipal(double emi, double interest) {
  return emi - interest;
}

double calculateOutstanding(double outstanding, double principal) {
  return outstanding - principal;
}

double calculatePartPayment(int month, int year, List<PartPayment> partPayments) {
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
    double tenureInMonths = widget.tenureType == "years" ? widget.tenure * 12 : widget.tenure;

    paymentSchedule = generatePaymentSchedule(
      widget.principleAmount,
      7.0, // Annual Interest Rate
      tenureInMonths,
      [], // Empty part payment list for simplicity
    );

    // Calculate totals for each year
    for (PartPayment payment in paymentSchedule) {
      int year = payment.year;
      totalPrincipalMap[year] = (totalPrincipalMap[year] ?? 0) + payment.principal;
      totalInterestMap[year] = (totalInterestMap[year] ?? 0) + payment.interest;
      totalPartPaymentMap[year] = (totalPartPaymentMap[year] ?? 0) + payment.partPayment;
      totalOutstandingMap[year] = payment.outstanding;
      yearExpandedMap[year] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrincipal = paymentSchedule.fold(0.0, (sum, item) => sum + item.principal);
    double totalInterest = paymentSchedule.fold(0.0, (sum, item) => sum + item.interest);
    double totalPartPayment = paymentSchedule.fold(0.0, (sum, item) => sum + item.partPayment);
    double totalOutstanding = paymentSchedule.isNotEmpty ? paymentSchedule.last.outstanding : 0.0;

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
      decoration: BoxDecoration(color: Colors.teal.shade400),
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Year', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Principal', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Interest', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Part Payment', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Total Payment', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Outstanding', style: TextStyle(color: Colors.white))),
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
        List<PartPayment> yearPayments = paymentSchedule.where((p) => p.year == year).toList();
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

  TableRow _buildExpandableRow(String year, bool isExpanded, double principalTotal, double interestTotal, double partPaymentTotal, double outstandingTotal) {
    return TableRow(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              yearExpandedMap[int.parse(year)] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            color: Colors.teal.shade100,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.teal,
                  ),
                  Text(
                    year,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildDataCell(principalTotal.toStringAsFixed(0)),
        _buildDataCell(interestTotal.toStringAsFixed(0)),
        _buildDataCell(partPaymentTotal.toStringAsFixed(0)),
        _buildDataCell((principalTotal + interestTotal + partPaymentTotal).toStringAsFixed(0)),
        _buildDataCell(outstandingTotal.toStringAsFixed(0)),
      ],
    );
  }

  TableRow _buildDataRow(String month, double principal, double interest, double partPayment, double totalPayment, double outstanding, Color bgColor) {
    return TableRow(
      decoration: BoxDecoration(color: bgColor),
      children: [
        _buildDataCell(month),
        _buildDataCell(principal.toStringAsFixed(0)),
        _buildDataCell(interest.toStringAsFixed(0)),
        _buildDataCell(partPayment.toStringAsFixed(0)),
        _buildDataCell(totalPayment.toStringAsFixed(0)),
        _buildDataCell(outstanding.toStringAsFixed(0)),
      ],
    );
  }

  Widget _buildDataCell(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      color: Colors.teal.shade50,
      child: Center(
        child: Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  TableRow _buildTotalsRow(double totalPrincipal, double totalInterest, double totalPartPayment) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.teal.shade300),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Totals', style: TextStyle(color: Colors.white))),
        ),
        _buildDataCell(totalPrincipal.toStringAsFixed(0)),
        _buildDataCell(totalInterest.toStringAsFixed(0)),
        _buildDataCell(totalPartPayment.toStringAsFixed(0)),
        _buildDataCell((totalPrincipal + totalInterest + totalPartPayment).toStringAsFixed(0)),
        _buildDataCell('0'),
      ],
    );
  }
}


