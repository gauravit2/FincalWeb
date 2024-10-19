import 'package:fincalweb_project/controller/part_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanDetail {
  final double principleAmount;
  final String month;
  final int year;
  final double principal;
  final double interest;
  final double partPayment;
  double outstanding;

  final PartPaymentController controller = Get.find<PartPaymentController>();

  LoanDetail({
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

class PaymentTable extends StatefulWidget {
  final List<LoanDetail> loanDetailList;

  const PaymentTable({
    required this.loanDetailList,
  });

  @override
  _PaymentTableState createState() => _PaymentTableState();
}

class _PaymentTableState extends State<PaymentTable> {
  Map<int, bool> yearExpandedMap = {};

  @override
  void initState() {
    super.initState();
    // Initialize any required state
  }

  @override
  Widget build(BuildContext context) {
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
            _buildTotalsRow(), // Call the totals row directly
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
    Set<int> years = widget.loanDetailList.map((p) => p.year).toSet();

    for (int year in years) {
      double totalPrincipal = 0;
      double totalInterest = 0;
      double totalPartPayment = 0;
      double outstandingTotal = 0;

      // Filter loan details for the specific year
      List<LoanDetail> yearPayments =
      widget.loanDetailList.where((p) => p.year == year).toList();

      // Calculate totals for the year based on monthly payments
      for (LoanDetail loanDetail in yearPayments) {
        totalPrincipal += loanDetail.principal;
        totalInterest += loanDetail.interest;
        totalPartPayment += loanDetail.partPayment;
        outstandingTotal = loanDetail.outstanding; // Assuming last entry is the final outstanding
      }

      rows.add(
        _buildExpandableRow(
          year.toString(),
          yearExpandedMap[year] ?? false,
          totalPrincipal,
          totalInterest,
          totalPartPayment,
          outstandingTotal,
        ),
      );

      if (yearExpandedMap[year] ?? false) {
        // Add monthly payment rows if expanded
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

  TableRow _buildTotalsRow() {
    double totalPrincipal = 0;
    double totalInterest = 0;
    double totalPartPayment = 0;

    for (LoanDetail loanDetail in widget.loanDetailList) {
      totalPrincipal += loanDetail.principal;
      totalInterest += loanDetail.interest;
      totalPartPayment += loanDetail.partPayment;
    }

    return TableRow(
      decoration: BoxDecoration(color: Colors.teal.shade100),
      children: [
        const Center(child: Text('Total')),
        _buildDataCell(totalPrincipal),
        _buildDataCell(totalInterest),
        _buildDataCell(totalPartPayment),
        _buildDataCell(totalPrincipal + totalInterest + totalPartPayment),
        _buildDataCell(widget.loanDetailList.last.outstanding),
      ],
    );
  }
}
