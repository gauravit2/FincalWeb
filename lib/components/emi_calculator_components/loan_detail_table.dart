import 'package:fincalweb_project/controller/part_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package

class LoanDetail {
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
    required this.outstanding
  });

  double get totalPayment => principal + interest + partPayment; // Compute on demand
}

class LoanDetailTable extends StatefulWidget {
  final List<LoanDetail> loanDetailList;

  const LoanDetailTable({
    required this.loanDetailList,
    Key? key,
  }) : super(key: key);

  static final GlobalKey<_LoanDetailTableState> tableKey = GlobalKey();

  @override
  _LoanDetailTableState createState() => _LoanDetailTableState();
}

class _LoanDetailTableState extends State<LoanDetailTable> {
  Map<int, bool> yearExpandedMap = {};
  late bool hasPartPayments; // Flag to determine if there are part payments

  @override
  void initState() {
    super.initState();
    hasPartPayments = widget.loanDetailList.any((loan) => loan.partPayment > 0);
  }

  // Method to collapse all rows
  void collapseAllRows() {
    setState(() {
      yearExpandedMap.clear(); // This will collapse all rows
    });
  }

  final NumberFormat numberFormat = NumberFormat.decimalPattern('en_IN'); // Use Indian format for commas

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
          // Remove const and make columnWidths dynamic
          columnWidths: {
            0: FlexColumnWidth(1.5),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            if (hasPartPayments) 3: FlexColumnWidth(2), // Dynamically add part payment column
            3: FlexColumnWidth(2.5), // Total Payment column (A+B+C)
            4: FlexColumnWidth(2),   // Outstanding column
          },
          children: [
            _buildHeaderRow(),
            ..._buildExpandableRows(),
            _buildTotalsRow(), // Call the totals row directly
          ],
        )

      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.teal.shade600),
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Year', style: TextStyle(color: Colors.white, fontSize: 16))),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Principal\n    (A)', style: TextStyle(color: Colors.white, fontSize: 16))),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Interest\n    (B)', style: TextStyle(color: Colors.white, fontSize: 16))),
        ),
        if (hasPartPayments) // Conditionally include the part payment column
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Part Payment\n         (C)', style: TextStyle(color: Colors.white, fontSize: 16))),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              hasPartPayments ? 'Total Payment\n      (A+B+C)' : 'Total Payment\n       (A+B)', // Conditionally change the text
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Outstanding', style: TextStyle(color: Colors.white, fontSize: 16))),
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
            color: Colors.teal.shade100, // Light teal background for year row
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(year,
                    style: const TextStyle(fontSize: 16), // Increased text size
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
        ),
        _buildDataCellWithBgColor(principalTotal, Colors.teal.shade100),
        _buildDataCellWithBgColor(interestTotal, Colors.teal.shade100),
        if (hasPartPayments) // Only show the part payment column if it exists
          _buildDataCellWithBgColor(partPaymentTotal, Colors.teal.shade100),
        _buildDataCellWithBgColor(principalTotal + interestTotal + partPaymentTotal, Colors.teal.shade100),
        _buildDataCellWithBgColor(outstandingTotal, Colors.teal.shade100),
      ],
    );
  }

  // Reuse the method for creating a data cell with background color
  Widget _buildDataCellWithBgColor(double value, Color bgColor) {
    return Container(
      color: bgColor, // Apply background color
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          numberFormat.format(value), // Format the number with commas
          style: const TextStyle(fontSize: 16), // Increased text size
        ),
      ),
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
            color: Colors.white, // White background for month row
            child: Center(child: Text(month))),
        _buildDataCell(principal),
        _buildDataCell(interest),
        if (hasPartPayments) // Only show the part payment cell if it exists
          _buildDataCell(partPayment),
        _buildDataCell(totalPayment),
        _buildDataCell(outstanding),
      ],
    );
  }

  // Method for creating a data cell with specific text size
  Widget _buildDataCell(double value, {double textSize = 16}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          numberFormat.format(value), // Format the number with commas
          style: TextStyle(fontSize: textSize), // Set the specified text size
        ),
      ),
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
      decoration: BoxDecoration(color: Colors.grey.shade300),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7.0), // Set top padding here
          child: const Center(
            child: Text('Total', style: TextStyle(fontSize: 16)), // Adjusted text size
          ),
        ),
        _buildDataCell(totalPrincipal, textSize: 16),
        _buildDataCell(totalInterest, textSize: 16),
        if (hasPartPayments) // Only show the part payment total if it exists
          _buildDataCell(totalPartPayment, textSize: 16),
        _buildDataCell(totalPrincipal + totalInterest + totalPartPayment, textSize: 16),
        _buildDataCell(widget.loanDetailList.last.outstanding, textSize: 16),
      ],
    );
  }
}